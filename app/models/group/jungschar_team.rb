# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::JungscharTeam < Group

  ### ROLES

  class Leitung < ::Role
    self.permissions = [:group_and_below_full]
  end

  class Mitarbeiter < ::Role
    self.permissions = [:group_read]
  end

  class Abteilungsleiter < Group::Jungschar::Abteilungsleiter; end
  class Coach < Group::Jungschar::Coach; end
  class Finanzverantwortlicher < Group::Jungschar::Finanzverantwortlicher; end
  class Adressverwalter < Group::Jungschar::Adressverwalter; end
  class Aktuar < Group::Jungschar::Aktuar; end
  class Busverwalter < Group::Jungschar::Busverwalter; end
  class FreierMitarbeiter < Group::Jungschar::FreierMitarbeiter; end
  class Hausverantwortlicher < Group::Jungschar::Hausverantwortlicher; end
  class Input < Group::Jungschar::Input; end
  class Laedeliverantwortlicher < Group::Jungschar::Laedeliverantwortlicher; end
  class Redaktor < Group::Jungschar::Redaktor; end
  class Regionaltreffenvertreter < Group::Jungschar::Regionaltreffenvertreter; end
  class Webmaster < Group::Jungschar::Webmaster; end
  class Werbung < Group::Jungschar::Werbung; end
  class Materialverantwortlicher < Group::Jungschar::Materialverantwortlicher; end
  class KontaktRegionalzeitschrift < Group::Jungschar::KontaktRegionalzeitschrift; end
  class VerantwortlicherPSA < Group::Jungschar::VerantwortlicherPSA; end
  class Jugendarbeiter < Group::Jungschar::Jugendarbeiter; end

  roles Abteilungsleiter,
        Coach,
        Finanzverantwortlicher,
        Adressverwalter,
        Aktuar,
        Busverwalter,
        FreierMitarbeiter,
        Hausverantwortlicher,
        Input,
        Laedeliverantwortlicher,
        Redaktor,
        Regionaltreffenvertreter,
        Webmaster,
        Werbung,
        Materialverantwortlicher,
        KontaktRegionalzeitschrift,
        VerantwortlicherPSA,
        Jugendarbeiter,
        Leitung,
        Mitarbeiter

end
