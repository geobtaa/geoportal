# Attempt to read Solr startup properties from config/solr.yml
unless Rails.env.development? || Rails.env.test?
  Rails.configuration.solr_configuration = YAML.load_file("#{Rails.root}/config/solr.yml") || {} rescue {}
  SolrWrapper.default_instance_options = {
      verbose: false,
      cloud: false,
      port: Rails.configuration.solr_configuration['port'] || '8983',
      version: Rails.configuration.solr_configuration['version'] || '5.5.0',
      instance_dir: Rails.configuration.solr_configuration['instance_dir'] || '/swadm/usr/local/solr',
      download_dir: Rails.configuration.solr_configuration['download_dir'] || 'tmp'
  }
end
