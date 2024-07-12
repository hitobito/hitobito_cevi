#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::VereinVorstand < Group::Vorstand
  ### ROLES

  class Praesident < ::Role
    self.permissions = [:layer_and_below_full, :contact_data]
  end

  class Finanzverantwortlicher < ::Role
    self.permissions = [:layer_and_below_read, :finance, :financials]
  end

  class Aktuar < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Mitglied < ::Role
    self.permissions = [:layer_and_below_read]
  end

  roles Praesident,
    Finanzverantwortlicher,
    Aktuar,
    Mitglied
end
