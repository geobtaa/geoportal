# lib/tasks/migrate/users.rake
require 'sidekiq/api'

namespace :geoportal do
  desc 'Stop sidekiq'
  task sidekiq_stop: :environment do
    sh "sudo systemctl stop sidekiq-geoportal.service || true"
    sleep(5)
    sh "sudo systemctl status --no-pager sidekiq-geoportal.service || true"
  end

  task sidekiq_start: :environment do
    sh "sudo systemctl start sidekiq-geoportal.service || true"
    sleep(5)
    sh "sudo systemctl status --no-pager sidekiq-geoportal.service || true"
  end

  desc 'Check sidekiq stats'
  task sidekiq_stats: :environment do
    # Check stats
    stats = Sidekiq::Stats.new
    puts stats.inspect
  end

  desc 'Clear sidekiq queues'
  task sidekiq_clear_queues: :environment do
    Sidekiq::RetrySet.new.clear
    Sidekiq::ScheduledSet.new.clear
    Sidekiq::Stats.new.reset
    Sidekiq::DeadSet.new.clear

    stats = Sidekiq::Stats.new
    stats.queues
    stats.queues.count
    stats.queues.clear

    queue = Sidekiq::Queue.new("default")
    queue.each do |job|
      job.delete
    end

    puts stats.inspect
  end
end
