# frozen_string_literal: true

#  Copyright (c) 2012-2024, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module HitobitoCevi
  class Wagon < Rails::Engine
    include Wagons::Wagon

    # Set the required application version.
    app_requirement ">= 0"

    # Add a load path for this specific wagon
    config.autoload_paths += %W[
      #{config.root}/app/abilities
      #{config.root}/app/domain
      #{config.root}/app/serializers
    ]

    config.to_prepare do # rubocop:disable Metrics/BlockLength
      # extend application classes here
      # models
      Group.include Cevi::Group
      Person.include Cevi::Person
      Role.include Cevi::Role

      Event::Kind.include Cevi::Event::Kind
      Event::Course.include Cevi::Event::Course
      Event::Role::AssistantLeader.permissions = [:participations_read]
      Event::Role::Leader.permissions << :manage_attendances

      # :financials may edit all people in a Group::Spender group.
      # :see_invisible_from_above may edit below people even when they
      # have visible_from_above = false.
      #   This only makes sense with :layer_and_below_full.
      Role::Permissions << :financials << :see_invisible_from_above

      # abilities
      EventAbility.include Cevi::EventAbility
      GroupAbility.include Cevi::GroupAbility
      PersonAbility.include Cevi::PersonAbility
      RoleAbility.include Cevi::RoleAbility
      VariousAbility.include Cevi::VariousAbility
      Event::ParticipationAbility.include Cevi::Event::ParticipationAbility
      PersonReadables.prepend Cevi::PersonReadables
      AbilityDsl::UserContext::LAYER_PERMISSIONS << :financials
      AbilityDsl::UserContext::GROUP_PERMISSIONS << :financials

      # domain
      Export::Tabular::Groups::List::EXCLUDED_ATTRS << :member_count
      Export::Tabular::People::PersonRow.include Cevi::Export::Tabular::People::PersonRow
      Export::Tabular::People::PeopleAddress.include Cevi::Export::Tabular::People::PeopleAddress
      Export::Tabular::People::ParticipationNdsRow.include(
        Cevi::Export::Tabular::People::ParticipationNdsRow
      )
      Import::Person.include Cevi::Import::Person

      whitelisted_person_attrs = [
        :additional_information,
        :canton,
        :confession,
        :correspondence_language,
        :joined,
        :language,
        :member_card_number,
        :nationality,
        :old_data,
        :profession,
        :salutation,
        :title
      ]

      TableDisplay.register_column(
        Person,
        TableDisplays::ShowFullColumn,
        whitelisted_person_attrs
      )

      TableDisplay.register_column(
        Event::Participation,
        TableDisplays::Event::Participations::ShowFullOrEventLeaderColumn,
        (whitelisted_person_attrs + [
          :j_s_number, :nationality_j_s
        ]).map { |col| "participant.#{col}" }
      )

      # serializers
      PersonSerializer.include Cevi::PersonSerializer
      PeopleSerializer.include Cevi::PeopleSerializer
      GroupSerializer.include Cevi::GroupSerializer
      EventParticipationSerializer.include Cevi::EventParticipationSerializer

      # Wizards
      Wizards::Steps::NewEventGuestParticipationForm.attribute :internal_comment, :string
      Wizards::Steps::NewEventGuestParticipationForm.attribute :payed, :boolean

      # controllers
      EventsController.include Cevi::EventsController
      Event::KindsController.permitted_attrs << :j_s_label
      Event::ParticipationsController.include Cevi::Event::ParticipationsController

      Group::PersonAddRequestsController.prepend Cevi::Group::PersonAddRequestsController

      PeopleController.include Cevi::PeopleController

      Person::LogController.prepend Cevi::Person::LogController

      ServiceTokensController.include Cevi::ServiceTokensController

      # jobs
      Export::EventParticipationsExportJob.include Cevi::Export::EventParticipationsExportJob

      # helpers
      Sheet::Group.include Cevi::Sheet::Group
      EventParticipationsHelper.prepend Cevi::EventParticipationsHelper

      # decorators
      PaperTrail::VersionDecorator.include Cevi::PaperTrail::VersionDecorator
      PersonDecorator.include Cevi::PersonDecorator
      Event::ParticipationDecorator.include Cevi::Event::ParticipationDecorator
    end

    initializer "cevi.add_settings" do |_app|
      Settings.add_source!(File.join(paths["config"].existent, "settings.yml"))
      Settings.reload!
    end

    initializer "cevi.add_inflections" do |_app|
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.irregular "census", "censuses"
      end
    end

    private

    def seed_fixtures
      fixtures = root.join("db", "seeds")
      ENV["NO_ENV"] ? [fixtures] : [fixtures, File.join(fixtures, Rails.env)]
    end
  end
end
