# lib/tasks/migrate/users.rake
require 'sidekiq/api'

namespace :geoportal do
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
    puts stats.inspect
  end
end
