#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::SportExterne < Group::Externe
  children Group::SportExterne

  ### ROLES

  class Verantwortlicher < ::Role
    self.permissions = [:group_and_below_full]
  end

  class Externer < ::Role
    self.visible_from_above = false
  end

  roles Verantwortlicher,
    Externer
end
