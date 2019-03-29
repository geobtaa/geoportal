namespace :geoportal do
  desc 'Purge URIs and State Transition History'
  task uri_purge: :environment do
    # Delete all Transitions and Uris
    UriTransition.destroy_all
    SolrDocumentUri.destroy_all
  end

  desc 'Process all URIs'
  task :uri_process_all, [:override_existing] => [:environment] do |_t, args|
    begin
      query = '*:*'
      index = Geoblacklight::SolrDocument.index
      results = index.send_and_receive(index.blacklight_config.solr_path,
                                       q: query,
                                       fl: "*",
                                       rows: 100_000_000)
      num_found = results.response[:numFound]
      doc_counter = 0
      results.docs.each do |document|
        begin
          document.uris.each do |uri|
            ProcessUriJob.perform_later(uri.id)
          end
        rescue Blacklight::Exceptions::RecordNotFound
          next
        end
      end
    end
  end

  desc 'Queue incomplete states for reprocessing'
  task uri_queue_incomplete_states: :environment do
    states = [
      :initialized,
      :queued,
      :processing,
      :failed
    ]

    states.each do |state|
      uris = SolrDocumentUri.in_state(state)

      puts "#{state} - #{uris.size}"

      uris.each do |uri|
        ProcessUriJob.perform_later(uri.id)
      end
    end
  end

  desc 'Hash of SolrDocumentUri state counts'
  task uri_states: :environment do
    states = [
      :initialized,
      :queued,
      :processing,
      :succeeded,
      :failed
    ]

    col_state = {}
    states.each do |state|
      uris = SolrDocumentUri.in_state(state)
      col_state[state] = uris.size
    end

    col_state.each do |col,state|
      puts "#{col} - #{state}"
    end
  end

  desc 'Write CSV formatted URI state report'
  task uri_report: :environment do
    # Create a CSV Dump of Results
    file = "#{Rails.root}/public/#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.uri_report.csv"

    uris = SolrDocumentUri.all

    CSV.open(file, 'w') do |writer|
      header = [
        "State",
        "URI ID",
        "URI Document UUID",
        "URI Key",
        "URI Value",
        "Doc Data Type",
        "Doc Title",
        "Doc Collection",
        "Doc Institution",
        "Error",
      ]

      writer << header

      uris.each do |uri|
        cat = Blacklight::SearchService.new(config: CatalogController.blacklight_config)
        begin
          resp, doc = cat.fetch(uri.document_id)
          writer << [
            uri.state_machine.current_state,
            uri.id,
            uri.document_id,
            uri.uri_key,
            uri.uri_value,
            doc._source['layer_geom_type_s'],
            doc._source['dc_title_s'],
            doc._source['dct_isPartOf_sm'].to_s,
            doc._source['dct_provenance_s'],
            uri.state_machine.last_transition.metadata['exception']
          ]
        rescue Exception => e
          puts "#{e.inspect}"
          puts "exception / #{uri.document_id}"
          next
        end
      end
    end

    AdminMailer.uri_analysis(file).deliver_now
  end
end
