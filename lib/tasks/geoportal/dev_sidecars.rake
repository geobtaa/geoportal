namespace :geoportal do
  desc 'Purge Sidecars and Images'
  task dev_sidecar_purge: :environment do
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
end
