# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::Ortsgruppe < Group

  self.layer = true

  children Group::Jungschar,
           Group::Verein,
           Group::TenSing,
           Group::Sport,
           Group::WeitereArbeitsgebiete

  ### ROLES

  class AdministratorCeviDB < ::Role
    self.permissions = [:layer_and_below_full, :see_invisible_from_above]
  end

  class Kassier < ::Role
    self.permissions = [:layer_and_below_read, :finance]
  end

  roles AdministratorCeviDB,
        Kassier

end
