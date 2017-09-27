namespace :geoportal do
  namespace :thumbnails do
    desc 'Delete all cached thumbnails'
    task delete: :environment do
      file_base_path = Settings.THUMBNAIL.FILE_BASE_PATH || "#{Rails.root}/public"
      thumb_path = Settings.THUMBNAIL.BASE_PATH || "thumbnails"
      FileUtils.rm_rf ("#{file_base_path}/#{thumb_path}")
    end
    desc 'Pre-cache a thumbnail'
    task :precache, [:doc_id, :timeout] => [:environment] do |t, args|
      begin
        fail 'Please supply required arguments [document_id, timeout]' unless args[:doc_id] && args[:timeout]
        document = Geoblacklight::SolrDocument.find(args[:doc_id])
        fail Blacklight::Exceptions::RecordNotFound if document[:layer_slug_s] != args[:doc_id]
        return unless document.available?
        thumbnail = Thumbnail.new(document)
        unless (thumbnail.file_exists? || thumbnail.service_url.nil?)
          PersistThumbnail.new({
            url: thumbnail.service_url,
            file_path: thumbnail.file_path_and_name,
            content_type: 'image/jpeg',
            timeout: args[:timeout].to_i
          }).create_file
        end
      end
    end
    desc 'Pre-cache all thumbnails for an institution'
    task :precache_all, [:institution, :timeout] => [:environment] do |t, args|
      begin
        fail 'Please supply required arguments[doc_id, institution, timeout]' unless args[:institution] && args[:timeout]
        query = "dct_provenance_s:#{args[:institution]}"
        layers = 'layer_slug_s, layer_id_s, dc_rights_s, dct_provenance_s dct_references_s'
        index = Geoblacklight::SolrDocument.index
        results = index.send_and_receive(index.blacklight_config.solr_path,
                                         { q: query,
                                           fl: layers,
                                           rows: 100000000 })
        num_found = results.response[:numFound]
        doc_counter = 0
        results.docs.each do |document|

          # Be polite and crawl slowly
          puts ".."
          sleep 2

          doc_counter += 1
          puts "#{document[:layer_slug_s]} (#{doc_counter}/#{num_found})"
          begin
            next unless document.available?
            thumbnail = Thumbnail.new(document)
            unless (thumbnail.file_exists? || thumbnail.service_url.nil?)
              PersistThumbnail.new({
                url: thumbnail.service_url,
                file_path: thumbnail.file_path_and_name,
                content_type: 'image/jpeg',
                timeout: args[:timeout].to_i
              }).create_file
            end
          rescue Blacklight::Exceptions::RecordNotFound
            next
          end
        end
      end
    end
  end
end
