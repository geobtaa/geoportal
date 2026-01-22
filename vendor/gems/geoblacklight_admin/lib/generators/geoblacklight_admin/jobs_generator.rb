# frozen_string_literal: true

require "rails/generators"

module GeoblacklightAdmin
  class JobsGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc <<-DESCRIPTION
      This generator makes the following changes to your application:
       1. Configures a default development environment queue adapter
    DESCRIPTION

    def config_development_jobs_queue_adapter
      job_config = <<-JOBS
        config.active_job.queue_adapter = :inline
      JOBS

      inject_into_file "config/environments/development.rb", job_config, before: /^end/
    end
  end
end
