# frozen_string_literal: true

#  Copyright (c) 2023, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Event::ApplicationAbility
  extend ActiveSupport::Concern

  included do
    on(Event::Application) do
      permission(:any).may(:approve).if_manage_attendances_in_event
      permission(:any).may(:reject).if_manage_attendances_in_event
    end
  end

  def if_manage_attendances_in_event
    permission_in_event?(:manage_attendances)
  end

end
