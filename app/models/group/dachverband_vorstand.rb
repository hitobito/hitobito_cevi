#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::DachverbandVorstand < Group::Vorstand
  ### ROLES

  class Praesidium < ::Role
    self.permissions = [:layer_read, :group_and_below_full, :contact_data]
  end

  class Finanzverantwortlicher < ::Role
    self.permissions = [:layer_read, :finance, :financials, :contact_data]
  end

  class Mitglied < ::Role
    self.permissions = [:layer_read, :contact_data]
  end

  roles Praesidium,
    Finanzverantwortlicher,
    Mitglied
end
