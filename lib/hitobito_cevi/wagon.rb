# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module HitobitoCevi
  class Wagon < Rails::Engine
    include Wagons::Wagon

    # Set the required application version.
    app_requirement '>= 0'

    # Add a load path for this specific wagon
    config.autoload_paths += %W( #{config.root}/app/abilities
                                 #{config.root}/app/domain
                                 #{config.root}/app/serializers )


    config.to_prepare do
      # extend application classes here
      Group.send          :include, Cevi::Group
      Person.send         :include, Cevi::Person

      Event::Kind.send    :include, Cevi::Event::Kind
      Event::Course.send  :include, Cevi::Event::Course

      Role::Permissions << :financials

      PersonAbility.send :include, Cevi::PersonAbility
      GroupAbility.send   :include, Cevi::GroupAbility
      VariousAbility.send :include, Cevi::VariousAbility
      PersonAccessibles.send :include, Cevi::PersonAccessibles

      PersonSerializer.send :include, Cevi::PersonSerializer
      GroupSerializer.send  :include, Cevi::GroupSerializer

      EventsController.send :include, Cevi::EventsController
      Event::KindsController.permitted_attrs += [:j_s_label]
      Event::ParticipationsController.send :include, Cevi::Event::ParticipationsController

      PeopleController.permitted_attrs +=
        [:title, :profession, :j_s_number, :joined, :ahv_number,
         :ahv_number_old, :nationality, :salutation_parents, :name_parents,
         :member_card_number, :salutation, :canton, :confession,
         :correspondence_language]

      Sheet::Group.send        :include, Cevi::Sheet::Group

      Export::Csv::People::PersonRow.send     :include, Cevi::Export::Csv::People::PersonRow
    end

    initializer 'cevi.add_settings' do |_app|
      Settings.add_source!(File.join(paths['config'].existent, 'settings.yml'))
      Settings.reload!
    end

    initializer 'jubla.add_inflections' do |_app|
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.irregular 'census', 'censuses'
      end
    end

    private

    def seed_fixtures
      fixtures = root.join('db', 'seeds')
      ENV['NO_ENV'] ? [fixtures] : [fixtures, File.join(fixtures, Rails.env)]
    end

  end
end
