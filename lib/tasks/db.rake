namespace :db do
  namespace :fixtures do
    desc 'Create YAML test fixtures from data in an existing database.'
    task :dump => :environment do
      sql  = "SELECT * FROM %s"
      skip_tables = ["schema_migrations"]
      ActiveRecord::Base.establish_connection(Rails.env)
      %w(groups roles people events).each do |table_name|
        i = "000"
        File.open(HitobitoCevi::Wagon.root.join("spec/fixtures/#{table_name}.yml"), 'w') do |file|
          rows = ActiveRecord::Base.connection.select_all(sql % table_name)

          records = rows.each_with_object({}) { |record, hash|
            record.reject! do |k|
              ['contact_id', 'created_at', 'updated_at', 'deleted_at',
               'creator_id', 'updater_id', 'deleter_id'].include?(k) || 
              record[k].blank?
            end
            hash["#{table_name}_#{i.succ!}"] = record
          }
          file.write(records.to_yaml)
        end
      end
    end
  end
end

