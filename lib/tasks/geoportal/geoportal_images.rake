# lib/tasks/migrate/users.rake
namespace :geoportal do
  desc 'Hash of SolrDocumentSidecar state counts'
  task sidecar_states: :environment do
    states = [
      :initialized,
      :queued,
      :processing,
      :succeeded,
      :failed,
      :placeheld
    ]

    image_states = {}
    states.each do |state|
      sidecars = SolrDocumentSidecar.in_state(state)
      image_states[state] = sidecars.size
    end

    image_states.each do |col,state|
      puts "#{col} - #{state}"
    end

    AdminMailer.image_states(image_states).deliver_now
  end

  desc 'Harvest images - Queue incomplete states for reprocessing'
  task queue_incomplete_states: :environment do
    states = [
      :initialized,
      :queued,
      :processing,
      :failed,
      :placeheld
    ]

    states.each do |state|
      sidecars = SolrDocumentSidecar.in_state(state)

      puts "#{state} - #{sidecars.size}"

      sidecars.each do |sc|
        cat = Blacklight::SearchService.new(config: CatalogController.blacklight_config)
        begin
          resp, doc = cat.fetch(sc.document_id)
          StoreImageJob.perform_later(doc.to_h)
          puts "queued / #{sc.document_id}"
        rescue Exception => e
          puts "#{e.inspect}"
          puts "orphaned / #{sc.document_id}"
        end
      end
    end
  end

  desc 'Failed State - Inspect metadata'
  task failed_state_inspect: :environment do
    states = [
      :failed
    ]

    states.each do |state|
      sidecars = SolrDocumentSidecar.in_state(state).each do |sc|
        puts "#{state} - #{sc.document_id} - #{sc.state_machine.last_transition.metadata.inspect}"
      end
    end
  end
end
