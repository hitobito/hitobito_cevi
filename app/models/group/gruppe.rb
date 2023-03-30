# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::Gruppe < Group

  class Gruppenleiter < Group::Stufe::Gruppenleiter; end
  class Minigruppenleiter < Group::Stufe::Minigruppenleiter; end
  class Helfer < Group::Stufe::Helfer; end
  class Teilnehmer < Group::Stufe::Teilnehmer; end

  roles Gruppenleiter,
        Minigruppenleiter,
        Helfer,
        Teilnehmer

end
