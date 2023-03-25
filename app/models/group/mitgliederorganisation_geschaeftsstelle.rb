# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::MitgliederorganisationGeschaeftsstelle < Group::Geschaeftsstelle

  ### ROLES

  class Geschaeftsleiter < ::Role
    self.permissions = [:layer_and_below_full, :contact_data, :finance]
  end

  class Angestellter < ::Role
    self.permissions = [:layer_and_below_full, :contact_data, :finance]
  end

  class Finanzverantwortlicher < ::Role
    self.permissions = [:layer_and_below_full, :finance, :financials, :contact_data]
  end

  class AdminOrtsgruppen < ::Role
    self.permissions = [:layer_and_below_full, :unconfined_below, :finance]
  end

  roles Geschaeftsleiter,
        Angestellter,
        Finanzverantwortlicher,
        AdminOrtsgruppen

end
