# frozen_string_literal: true

namespace :geoportal do
  desc 'Hash of SolrDocumentSidecar state counts'
  task sidecar_states: :environment do
    states = %i[initialized queued processing failed placeheld]

    col_state = {}
    states.each do |state|
      sidecars = SolrDocumentSidecar.in_state(state)
      col_state[state] = sidecars.size
    end

    col_state.each do |col, state|
      puts "#{col} - #{state}"
    end
  end

  desc 'Queue incomplete states for reprocessing'
  task queue_incomplete_states: :environment do
    states = %i[initialized queued processing failed placeheld]

    states.each do |state|
      sidecars = SolrDocumentSidecar.in_state(state)

      puts "#{state} - #{sidecars.size}"

      sidecars.each do |sc|
        cat = CatalogController.new
        begin
          _resp, doc = cat.fetch(sc.document_id)
          StoreImageJob.perform_later(doc.to_h)
        rescue Exception => e
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
      SolrDocumentSidecar.in_state(state).each do |sc|
        puts "#{state} - #{sc.document_id} - #{sc.state_machine.last_transition.metadata.inspect}"
      end
    end
  end
end
