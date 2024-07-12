#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::DachverbandGeschaeftsstelle < Group::Geschaeftsstelle
  ### ROLES

  class Geschaeftsleiter < ::Role
    self.permissions = [:layer_full, :contact_data, :finance]
  end

  class Angestellter < ::Role
    self.permissions = [:layer_full, :contact_data, :finance]
  end

  class Finanzverantwortlicher < ::Role
    self.permissions = [:layer_full, :finance, :financials, :contact_data]
  end

  roles Geschaeftsleiter,
    Angestellter,
    Finanzverantwortlicher
end
