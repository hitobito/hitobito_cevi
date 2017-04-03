# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Export::Tabular::People::PeopleAddress

  extend ActiveSupport::Concern

  included do
    alias_method_chain :person_attributes, :cevi_fields
  end

  private

  def person_attributes_with_cevi_fields
    person_attributes_without_cevi_fields + [:salutation_parents, :name_parents, :ortsgruppe_id]
  end

end
