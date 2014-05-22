# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

# Original from: https://github.com/thams/db_fixtures_dump/
namespace :db do
  namespace :fixtures do
    desc 'Dumps some models into fixtures.'
    task :dump => :environment do
      models = [Group]

      models.each do |model|
        next unless model.ancestors.include?(ActiveRecord::Base)

        puts "Dumping model: " + model.class_name
        entries = model.find(:all, :order => 'id ASC')

        model_file = HitobitoCevi::Wagon.root.join('spec/fixtures/' + model.table_name + '.yml')
        File.open(model_file, 'w') do |f|
          entries.each do |a|
            key = "_#{a.class.table_name}_#{a.id}_"
            attrs = a.attributes

            if model == Group
              attrs['parent_id'] = attrs['parent_id'] &&
                "_#{model.table_name}_#{attrs['parent_id']}_"
              attrs['layer_group_id'] = attrs['layer_group_id'] &&
                "<%= ActiveRecord::FixtureSet.identify(" +
                ":_#{model.table_name}" +
                "_#{attrs['layer_group_id']}_" +
                ") %>"
            end

            attrs.delete_if do |k, v|
              ['id', 'contact_id', 'created_at', 'updated_at', 'deleted_at',
               'creator_id', 'updater_id', 'deleter_id'].include?(k) ||
              v.nil?
            end

            output = {key => attrs}
            f << output.to_yaml.gsub(/^---\s?\n/,'') + "\n"
          end
        end
      end
    end
  end
end
