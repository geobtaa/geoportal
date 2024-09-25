# frozen_string_literal: true
require "addressable/uri"
require "net/http"
require "net/ftp"

class UriService
  def initialize(solr_document_uri)
    @uri = solr_document_uri
    @metadata = {
      'solr_doc_id' => @uri.document_id,
      'uri_key'     => @uri.uri_key,
      'uri_value'   => @uri.uri_value,
      'solr_version' => @uri.version
    }

    @uri.state_machine.transition_to!(:processing, @metadata)

    @logger = ActiveSupport::TaggedLogging.new(
      Logger.new(
        File.join(
          Rails.root, '/log/', "uri_service_#{Rails.env}.log"
        )
      )
    )
  end

  def process
    sleep(1)

    uri = normalize_uri(@uri.uri_value)

    if uri.scheme.start_with?('http')
      process_http_uri(uri)
    elsif uri.scheme.start_with?('ftp')
      process_ftp_uri(uri)
    else
      @uri.state_machine.transition_to!(:failed, @metadata.merge('error' => 'Unsupported URI scheme'))
    end

    log_output
  rescue => e
    @metadata['exception'] = e.inspect
    @uri.state_machine.transition_to!(:failed, @metadata)
    log_output
  end

  private

  def process_http_uri(uri)
    result = check_uri(uri)

    if result.instance_of?(Good) || result.instance_of?(Redirect)
      @uri.state_machine.transition_to!(:succeeded, @metadata)
    else
      @uri.state_machine.transition_to!(:failed, @metadata)
    end
  end

  def process_ftp_uri(uri)
    Net::FTP.open(uri.host) do |ftp|
      ftp.passive = true
      ftp.login 'anonymous', 'anonymous@google.com'
  
      path = uri.path.sub(/^\//, '') # Remove leading slash if present
      if File.extname(path).size > 0
        begin
          size = ftp.size(path)
          if size > 0
            @uri.state_machine.transition_to!(:succeeded, @metadata)
          else
            @uri.state_machine.transition_to!(:failed, @metadata.merge('error' => 'File size is 0'))
          end
        rescue Net::FTPPermError
          @uri.state_machine.transition_to!(:failed, @metadata.merge('error' => 'File not found'))
        end
      else
        begin
          if check_ftp_path(ftp, path)
            @uri.state_machine.transition_to!(:succeeded, @metadata)
          else
            @uri.state_machine.transition_to!(:failed, @metadata.merge('error' => 'Directory not found'))
          end
        rescue Net::FTPPermError
          @uri.state_machine.transition_to!(:failed, @metadata.merge('error' => 'Directory not found'))
        end
      end
    end
  rescue Net::FTPPermError, Net::FTPReplyError => e
    @uri.state_machine.transition_to!(:failed, @metadata.merge('error' => e.message))
  end
  
  def check_ftp_path(ftp, path)
    ftp.chdir(path)
    ftp.pwd == "/#{path}"
  end

  def check_uri(uri, redirected=false)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.start do
      http.request_get(uri.request_uri) do |response|
        case response
        when Net::HTTPSuccess then
          if redirected
            return Redirect.new(:final_destination_uri_string => uri.to_s)
          else
            return Good.new(:uri_string => uri.to_s)
          end
        when Net::HTTPMovedPermanently then
          uri =
            if response['location'].match(/\:\/\//) # Allows for https://
              URI(response['location'])
            else
              # If the redirect is relative we need to build a new uri
              # using the current uri as a base.
              URI.join("#{uri.scheme}://#{uri.host}:#{uri.port}", response['location'])
            end
          return check_uri(normalize_uri(uri), true)
        when Net::HTTPRedirection then
          uri =
            if response['location'].match(/\:\/\//) # Allows for https://
              URI(response['location'])
            else
              # If the redirect is relative we need to build a new uri
              # using the current uri as a base.
              URI.join("#{uri.scheme}://#{uri.host}:#{uri.port}", response['location'])
            end
          return check_uri(normalize_uri(uri), true)
        else
          @metadata['error'] = response
          return Error.new(:uri_string => uri.to_s, :error => response)
        end
      end
    end
  end

  def check_ftp_path(ftp, path)
    path.split('/').each do |dir|
      ftp.chdir(dir)
      if "/#{path}" == ftp.pwd
        true
      else
        false
      end
    end
  end

  def normalize_uri(uri_string)
    URI.parse(Addressable::URI.parse(uri_string).normalize.to_s)
  end

  def log_output
    @metadata["state"] = @uri.state_machine.current_state
    @metadata.each do |key,value|
      @logger.tagged(@uri.id, key.to_s) { @logger.info value }
    end
  end
end

# Abstract base class for representing the results of checking one URI.
class Result
  attr_accessor :uri_string

  # A new Result object instance.
  #
  # @param params [Hash] A hash of parameters.  Expects :uri_string.
  def initialize(params)
    @uri_string = params[:uri_string]
  end
end

# A Good Result.  The URL is valid.
class Good < Result
end

# A Redirect to another URL.
class Redirect < Result
  attr_reader :good
  attr_reader :final_destination_uri_string

  # A new LinkChecker::Redirect object.
  #
  # @param params [Hash] A hash of parameters.  Expects :final_destination_uri_string,
  # which is the URL that the original :uri_string redirected to.
  def initialize(params)
    @final_destination_uri_string = params[:final_destination_uri_string]
    @good = params[:good]
    super(params)
  end
end

# A Error result.  The URL is not valid for some reason.  Any reason, other than a 200
# HTTP response.
#
# @param params [Hash] A hash of parameters.  Expects :error, which is a string
# representing the error.
class Error < Result
  attr_reader :error
  def initialize(params)
    @error = params[:error]
    super(params)
  end
end