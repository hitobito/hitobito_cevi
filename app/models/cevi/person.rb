#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Person
  extend ActiveSupport::Concern

  CONFESSIONS = %w[ev rk ck none other].freeze
  SALUTATIONS = %w[formal informal].freeze

  included do
    Person::PUBLIC_ATTRS.push(:salutation_parents, :name_parents, :ortsgruppe_id)

    belongs_to :ortsgruppe, class_name: "Group::Ortsgruppe"

    include I18nSettable
    include I18nEnums

    i18n_enum :confession, CONFESSIONS
    i18n_setter :confession, CONFESSIONS

    i18n_enum :salutation, SALUTATIONS
    i18n_setter :salutation, SALUTATIONS
  end

  def canton
    self[:canton]
  end

  def canton_label
    Cantons.full_name(canton)
  end

  def ortsgruppe_label
    ortsgruppe && (ortsgruppe.short_name.presence || ortsgruppe.name.presence)
  end
end
