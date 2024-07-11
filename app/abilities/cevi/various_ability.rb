#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::VariousAbility
  extend ActiveSupport::Concern

  included do
    on(Census) do
      permission(:layer_and_below_full).may(:manage).if_mitarbeiter_gs
    end
  end

  def if_mitarbeiter_gs
    user.roles.any? do |r|
      r.is_a?(Group::Dachverband::Administrator)
    end
  end
end
