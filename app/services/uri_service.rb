# frozen_string_literal: true
require "addressable/uri"
require "net/http"
require "net/ftp"

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

class UriService
  def initialize(solr_document_uri)
    @uri = solr_document_uri
    @metadata = Hash.new
    @metadata['solr_doc_id'] = @uri.document_id
    @metadata['solr_version'] = @uri.version

    @uri.state_machine.transition_to!(:processing, @metadata)

    @logger = ActiveSupport::TaggedLogging.new(
      Logger.new(
        File.join(
          Rails.root, '/log/', "uri_service_#{Rails.env}.log"
        )
      )
    )
  end

  # Captures the uri's validity in SolrDocumentUri
  # @return [Boolean]
  #
  # @TODO: EWL
  def process
    # Gentle hands.
    sleep(1)

    uri = Addressable::URI.parse(@uri.uri_value)

    if uri.start_with?('http')
      result = check_uri(uri)

      if result.instance_of?(Good)
        @uri.state_machine.transition_to!(:succeeded, @metadata)
      elsif result.instance_of?(Redirect)
        @metadata["final_destination_uri_string"] = result.final_destination_uri_string
        @uri.state_machine.transition_to!(:succeeded, @metadata)
      else
        @uri.state_machine.transition_to!(:failed, @metadata)
      end

    elsif uri.start_with?('ftp')

      Net::FTP.open(uri.host) do |ftp|
        ftp.passive = true
        ftp.login 'anonymous', 'anonymous@google.com'

        # Check for file extension
        if File.extname(uri.path).size > 0
          size = ftp.size(uri.path)
          if size > 0
            @uri.state_machine.transition_to!(:succeeded, @metadata)
          end
        elsif check_ftp_path(ftp, uri.path)
          @uri.state_machine.transition_to!(:succeeded, @metadata)
        else
          @uri.state_machine.transition_to!(:failed, @metadata)
        end
      end
    end
    log_output

  rescue Exception => invalid
    @metadata['exception'] = invalid.inspect
    @uri.state_machine.transition_to!(:failed,@metadata)
    log_output
  end

  def log_output
    @metadata.each do |key,value|
      @logger.tagged(@document.id, key.to_s) { @logger.info value }
    end
  end

  def check_uri(uri, redirected=false)
    # Don't trust redirect URI values
    uri = Addressable::URI.parse(uri)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.start do
      http.request_get(uri.normalize.to_s) do |response|
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
          return check_uri(uri, true)
        when Net::HTTPRedirection then
          uri =
            if response['location'].match(/\:\/\//) # Allows for https://
              URI(response['location'])
            else
              # If the redirect is relative we need to build a new uri
              # using the current uri as a base.
              URI.join("#{uri.scheme}://#{uri.host}:#{uri.port}", response['location'])
            end
          return check_uri(uri, true)
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
end
