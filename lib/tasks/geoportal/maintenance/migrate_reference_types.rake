namespace :geoportal do
  namespace :maintenance do
    desc "Migrate reference types from 10 to 7 and remove reference_type_id 10"
    task migrate_full_layer_reference_types: :environment do
      total = DocumentDistribution.where(reference_type_id: 10).count
      processed = 0
      
      puts "Starting migration of #{total} records..."
      
      DocumentDistribution.where(reference_type_id: 10)
                         .find_each(batch_size: 1000) do |distribution|
        begin
          if ENV['TRIAL_RUN'] && ENV['TRIAL_RUN'] == 'false'
            begin
              distribution.update!(reference_type_id: 7)
            rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
              # If we get a duplicate key error or validation error, delete the record with reference_type_id 10
              distribution.destroy
            end
          else
            puts "Will update #{distribution.id}"
          end
        end
        
        processed += 1
        if (processed % 1000).zero?
          puts "Processed #{processed} of #{total} records (#{(processed.to_f / total * 100).round(2)}%)"
        end
      end
      
      puts "Completed processing #{processed} records"

      if ENV['TRIAL_RUN'] && ENV['TRIAL_RUN'] == 'false'
        ReferenceType.where(id: 10).destroy_all
        puts "Removed reference_type_id 10"
      else
        puts "Skipping removal of reference_type_id 10"
      end
    end
  end
end