namespace :geoportal do
  desc "Download the B1G Geoportal data.json file."
  task :b1g_download_data do
    require 'down'
    begin
      Down.download("https://geo.btaa.org/data.json", destination: "#{Rails.root}/tmp/b1g_data.json")

      puts "Success - B1G Geoportal data downloaded to tmp/b1g_data.json"
    rescue
      puts "Error - could not download B1G Geoportal data!"
    end
  end

  desc "Download the B1G Geoportal data."
  task :b1g_clean_data => [:b1g_download_data] do
    begin
      # Loop it
      cleaned_data = Array.new
      data = JSON.parse(IO.read('tmp/b1g_data.json'))
      data.each do |doc|
        cleaned = doc.except!(
          "_version_",
          "timestamp",
          "solr_bboxtype",
          "solr_bboxtype__minX",
          "solr_bboxtype__minY",
          "solr_bboxtype__maxX",
          "solr_bboxtype__maxY"
        )

        cleaned_data << cleaned
      end

      IO.write('tmp/b1g_cleaned_data.json', cleaned_data.to_json)

      puts "Success - B1G data extracted to tmp/b1g_cleaned_data.json"
    rescue
      puts "Error - could not process B1G data!"
    end
  end

  desc "Index the B1G Geoportal data."
  task :b1g_index_data => [:b1g_clean_data] do
    require 'net/http'
    require 'uri'

    uri = URI.parse("http://localhost:8983/solr/geoportal-core-development/update/json?commit=true")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = File.read("#{Rails.root}/tmp/b1g_cleaned_data.json")

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    puts response.code
  end
end
