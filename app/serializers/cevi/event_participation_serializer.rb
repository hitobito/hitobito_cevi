#  Copyright (c) 2012-2019, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::EventParticipationSerializer
  extend ActiveSupport::Concern

  included do
    extension(:attrs) do |_|
      map_properties :payed
    end
  end
end
