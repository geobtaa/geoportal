namespace :geoportal do
  desc 'Generate JSON dump of Solr documents'
  task export_data: :environment do
    file = "#{Rails.root}/public/data.json"

    index = Geoblacklight::SolrDocument.index
    results = index.send_and_receive(
      index.blacklight_config.solr_path,
      q: '*:*',
      fl: '*',
      rows: 100_000_000,
      wq: 'json'
    )

    File.open(file, "w"){|f| f.write(results["response"]["docs"].to_json)}
  end
end
