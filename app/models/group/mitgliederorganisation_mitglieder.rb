# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::MitgliederorganisationMitglieder < Group::Mitglieder

  children Group::MitgliederorganisationMitglieder


  ### ROLES

  class Adressverwalter < ::Role
    self.permissions = [:group_and_below_full]
  end

  class Mitglied < ::Role; end

  roles Adressverwalter,
        Mitglied

end
