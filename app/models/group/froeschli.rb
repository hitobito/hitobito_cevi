#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::Froeschli < Group
  children Group::Froeschli

  ### ROLES

  class Froeschlihauptleiter < ::Role
    self.permissions = [:layer_and_below_read, :group_and_below_full]
  end

  class Froeschlileiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Teilnehmer < ::Role
    self.permissions = [:group_read]

    self.visible_from_above = false
  end

  roles Froeschlihauptleiter,
    Froeschlileiter,
    Teilnehmer
end
