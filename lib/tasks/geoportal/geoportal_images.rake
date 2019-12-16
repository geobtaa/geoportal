# frozen_string_literal: true

namespace :geoportal do
  desc 'Hash of SolrDocumentSidecar state counts'
  task sidecar_states: :environment do
    states = %i[
      initialized
      queued
      processing
      succeeded
      failed
      placeheld
    ]

    image_states = {}
    states.each do |state|
      sidecars = SolrDocumentSidecar.in_state(state)
      image_states[state] = sidecars.size
    end

    image_states.each do |col, state|
      puts "#{col} - #{state}"
    end

    AdminMailer.image_states(image_states).deliver_now
  end

  desc 'Harvest images - Queue incomplete states for reprocessing'
  task queue_incomplete_states: :environment do
    puts "Deprecated / Instead try: bundle exec rake gblsci:images:harvest_retry"
  end

  desc 'Failed State - Inspect metadata'
  task failed_state_inspect: :environment do
    puts "Deprecated / Instead try: bundle exec rake gblsci:images:harvest_failed_state_inspect"
  end
end
