require 'json'
require 'uri'
require 'net/http'
require 'net/ftp'
require 'openssl'
require 'csv'

# lib/tasks/migrate/users.rake
namespace :geoportal do
  desc 'Test URIs stored in Solr index'
  task test_uris: :environment do
    RESULTS = Hash.new

    # Abstract base class for representing the results of checking one URI.
    class Result
      attr_accessor :uri_string

      # A new LinkChecker::Result object instance.
      #
      # @param params [Hash] A hash of parameters.  Expects :uri_string.
      def initialize(params)
        @uri_string = params[:uri_string]
      end
    end

    # A good result.  The URL is valid.
    class Good < Result
    end

    # A redirection to another URL.
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

    # A bad result.  The URL is not valid for some reason.  Any reason, other than a 200
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

    def check_uri(uri, redirected=false)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == "https"
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.start do
        path = (uri.path.empty?) ? '/' : uri.path
        http.request_get(path) do |response|
          case response
          when Net::HTTPSuccess then
            if redirected
              return Redirect.new(:final_destination_uri_string => uri.to_s)
            else
              return Good.new(:uri_string => uri.to_s)
            end
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

    def process(doc, type, string, csv)

      # Init results doc
      if !RESULTS.key?(doc['uuid'])
        RESULTS[doc['uuid']] = {}
      end


      if string.start_with?('http')
        uri = URI(string)
        RESULTS[doc['uuid']][type] = check_uri(uri)
        if RESULTS[doc['uuid']][type].instance_of?(Good)
          print "."
        else
          print "F"
        end
        csv << [RESULTS[doc['uuid']][type].class, doc['uuid'], type, string, doc['dct_provenance_s'], doc['dc_title_s']]

      elsif string.start_with?('ftp')
        uri = URI(string)
        Net::FTP.open(uri.host) do |ftp|
          ftp.passive = true
          ftp.login 'anonymous', 'anonymous@google.com'

          # Check for file extension
          if File.extname(uri.path).size > 0
            size = ftp.size(uri.path)
            if size > 0
              print ":"
              csv << ['Good FTP', doc['uuid'], type, string, doc['dct_provenance_s'], doc['dc_title_s']]
            end
          elsif check_ftp_path(ftp, uri.path)
            print ":"
            csv << ['Good FTP', doc['uuid'], type, string, doc['dct_provenance_s'], doc['dc_title_s']]
          else
            csv << ['Error FTP', doc['uuid'], type, string, doc['dct_provenance_s'], doc['dc_title_s']]
            print "?"
          end
        end
      end
    end

    # Start
    t1 = Time.now
    puts t1

    # Read response json from Solr
    # @TODO: Blacklight/Solr connection, query
    # For now, just run a query like this...
    # https://geo.btaa.org/solr/blacklightcore/select?q=*%3A*&wt=json&indent=true&fl=uuid,dct_references_s,dct_provenance_s,dc_title_s&rows=10000
    #
    # Just make sure the rows param is big enough to capture all the records.
    json = JSON.parse(File.open(Rails.root.join('tmp', 'uris', 'uris.json'),'r').read)

    # Count of documents processed
    count = 0

    # Write results to CSV file
    # @TODO: Where should this report land? Date stamp it.
    CSV.open(Rails.root.join('tmp', 'uris', 'results.csv'), "w+") do |csv|
      json['response']['docs'].each_slice(1000) do |slice|
        slice.each do |doc|
          sleep(1)
          refs = JSON.parse(doc['dct_references_s'])
          refs.each do |key,value|
            begin
              process(doc, key, value, csv)
            rescue Exception => e
              print "!"
              csv << ["FAILED", doc['uuid'], key, value, doc['dct_provenance_s'], doc['dc_title_s'], e.inspect]
            end
          end
        end
        count = count + 1000
        print count
      end
    end

    # End
    t2 = Time.now
    puts t2 - t1
  end
end
