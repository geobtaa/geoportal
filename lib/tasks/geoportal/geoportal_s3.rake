namespace :geoportal do
  namespace :s3 do
    desc 'Clear S3 Cache - removes cached files older than 7 days'
    task clear_cache: :environment do
      Shrine.storages[:cache].clear! { |object| object.last_modified < Time.now - 7*24*60*60 }
    end
  end
end