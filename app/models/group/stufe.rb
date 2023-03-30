# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::Stufe < Group

  ### ROLES

  class Stufenleiter < ::Role
    self.permissions = [:layer_and_below_read, :group_and_below_full]
  end

  class MiniChef < ::Role
    self.permissions = [:layer_and_below_read, :group_and_below_full]
  end

  class Gruppenleiter < ::Role
    self.permissions = [:layer_and_below_read, :group_and_below_full]
  end

  class Minigruppenleiter < ::Role
    self.permissions = [:layer_and_below_read, :group_and_below_full]
  end

  class Helfer < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Teilnehmer < ::Role
    self.permissions = [:group_read]

    self.visible_from_above = false
  end

  children Group::Gruppe

  roles Stufenleiter,
        MiniChef,
        Gruppenleiter,
        Minigruppenleiter,
        Helfer,
        Teilnehmer

end
