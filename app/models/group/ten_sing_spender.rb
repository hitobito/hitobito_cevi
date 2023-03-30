# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::TenSingSpender < Group::Spender

  children Group::TenSingSpender

  ### ROLES

  class Spender < ::Role::Spender
  end

  class SpendenVerwalter < ::Role
    self.permissions = [:group_and_below_full]
  end

  roles Spender,
        SpendenVerwalter

end
