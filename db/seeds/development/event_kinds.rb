# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.


quali_kinds = QualificationKind.seed(:id,
 # J+S-Leiter/-in im Sportfach Lagersport/Trekking
 {id: 1,
  validity: 2},

 # J+S-Lagerleiter im Sportfach Lagersport/Trekking
 {id: 2,
  validity: 2}
)

QualificationKind::Translation.seed(:label,
 {qualification_kind_id: quali_kinds[0].id,
  locale: 'de',
  label: 'J+S-Leiter/-in im Sportfach Lagersport/Trekking'},

 {qualification_kind_id: quali_kinds[1].id,
  locale: 'de',
  label: 'J+S-Lagerleiter im Sportfach Lagersport/Trekking'}
)


event_kinds = Event::Kind.seed(:id,
 # Vorkurs
 {id: 1},

 # Helfer/-innen-Kurs
 {id: 2},

 # Gruppenleiter/-innen-Kurs 1
 {id: 3},

 # Gruppenleiter/-innen-Kurs 2
 {id: 4},

 # Gruppenleiter/-innen-Kurs 3
 {id: 5},

 # Lagerleiter/-innen-Modul
 {id: 6},

 # Stufenleiter/-innen-Kurs
 {id: 7}
)

Event::Kind::Translation.seed(:short_name,
 {event_kind_id: event_kinds[0].id,
  locale: 'de',
  label: 'Vorkurs',
  short_name: 'VOKU'},

 {event_kind_id: event_kinds[1].id,
  locale: 'de',
  label: 'Helfer/-innen-Kurs',
  short_name: 'HEKU'},

 {event_kind_id: event_kinds[2].id,
  locale: 'de',
  label: 'Gruppenleiter/-innen-Kurs 1',
  short_name: 'GLK1'},

 {event_kind_id: event_kinds[3].id,
  locale: 'de',
  label: 'Gruppenleiter/-innen-Kurs 2',
  short_name: 'GLK2'},

 {event_kind_id: event_kinds[4].id,
  locale: 'de',
  label: 'Gruppenleiter/-innen-Kurs 3',
  short_name: 'GLK3'},

 {event_kind_id: event_kinds[5].id,
  locale: 'de',
  label: 'Lagerleiter/-innen-Modul',
  short_name: 'LLM'},

 {event_kind_id: event_kinds[6].id,
  locale: 'de',
  label: 'Stufenleiter/-innen-Kurs',
  short_name: 'SLK'}
)

Event::KindQualificationKind.seed(:id,
  {id: 1,
   event_kind_id: event_kinds[4].id,
   qualification_kind_id: quali_kinds[0].id,
   category: :qualification,
   role: :participant},

  {id: 2,
   event_kind_id: event_kinds[5].id,
   qualification_kind_id: quali_kinds[1].id,
   category: :qualification,
   role: :participant}
)
