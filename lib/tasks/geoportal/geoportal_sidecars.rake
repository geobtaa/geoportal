namespace :geoportal do
  desc 'Purge Sidecars and Images'
  task sidecar_purge: :environment do
    # Remove images
    sidecars = SolrDocumentSidecar.all
    sidecars.each do |sc|
      sc.remove_image!
      sc.save
    end

    # Delete all Transitions and Sidecars
    ImageUploadTransition.destroy_all
    SolrDocumentSidecar.destroy_all
  end

  desc 'Write state report'
  task sidecar_report: :environment do
    # Create a CSV Dump of Results
    file = "#{Rails.root}/public/#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.sidecar_report.csv"

    sidecars = SolrDocumentSidecar.all

    CSV.open(file, 'w') do |writer|
      sidecars.each do |sc|
        cat = CatalogController.new
        begin
          resp, doc = cat.fetch(sc.document_id)
          writer << [sc.id, sc.document_id, sc.state_machine.current_state, doc._source['dc_title_s'], doc._source['dct_isPartOf_sm'].join(", "), doc._source['dct_provenance_s'], sc.state_machine.last_transition.metadata['exception']]
        rescue
          puts "orphaned / #{sc.document_id}"
          next
        end
      end
    end
  end
end
