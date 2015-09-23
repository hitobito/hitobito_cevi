# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Event::ParticipationAbility
  extend ActiveSupport::Concern

  included do
    on(Event::Participation) do
      permission(:unconfined_below).
        may(:create_tentative).
        person_in_same_layer_or_below
    end
  end

  def person_in_same_layer_or_below
    person.nil? || permission_in_layers?(person.groups_hierarchy_ids)
  end

end
