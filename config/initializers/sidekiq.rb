Sidekiq.configure_server do |config|
  config = ActiveRecord::Base.configurations[Rails.env] || Rails.application.config.database_configuration[Rails.env]
  config['pool'] = Sidekiq.options[:concurrency] + 2
  ActiveRecord::Base.establish_connection(config)
  Rails.logger.debug("Connection Pool size for Sidekiq Server is now: #{ActiveRecord::Base.connection.pool.instance_variable_get('@size')}")
end
