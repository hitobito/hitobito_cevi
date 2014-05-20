# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require Rails.root.join('db', 'seeds', 'support', 'group_seeder')

seeder = GroupSeeder.new
srand(42)

dachverband = Group::Dachverband.seed_once(:parent_id,
  {name: 'CEVI Schweiz',
   short_name: 'CEVI'}
)[0]

Group::DachverbandVorstand.seed(:name, :parent_id,
  {name: 'Vorstand',
   parent_id: dachverband.id}
)[0]

Group::DachverbandGeschaeftsstelle.seed(:name, :parent_id,
  {name: 'Geschäftsstelle',
   parent_id: dachverband.id}
)[0]

Group::DachverbandGremium.seed(:name, :parent_id,
  {name: 'Revisionsstelle',
   parent_id: dachverband.id}
)[0]

#unless ch.address.present?
#  ch.update_attributes(seeder.group_attributes)
#  ch.default_children.each do |child_class|
#    child_class.first.update_attributes(seeder.group_attributes)
#  end
#end

zhshgl, be, alpin = Group::Mitgliederorganisation.seed(:name, :parent_id,
  {name: 'Cevi Regionalverband ZH-SH-GL',
   short_name: 'RV ZH-SH-GL',
   address: 'Sihlstrasse 33',
   zip_code: 8021,
   town: 'Zürich',
   country: 'Schweiz',
   email: 'rv-zhshgl@example.com',
   parent_id: dachverband.id},

  {name: 'Cevi Region Bern',
   short_name: 'RV BE',
   address: 'Rabbentalstrasse 69',
   zip_code: 3013,
   town: 'Bern',
   country: 'Schweiz',
   email: 'rv-bern@example.com',
   parent_id: dachverband.id},

  {name: 'Cevi Alpin',
   short_name: 'AG ALP',
   address: 'Ausser Dorf 2',
   zip_code: 7260,
   town: 'Davos',
   country: 'Schweiz',
   email: 'alpin@example.com',
   parent_id: dachverband.id}
)

[zhshgl, be, alpin].each do |s|
  seeder.seed_social_accounts(s)
end

Group::MitgliederorganisationVorstand.seed(:name, :parent_id,
  {name: 'Zentralvorstand',
   parent_id: zhshgl.id}
)[0]

Group::MitgliederorganisationGeschaeftsstelle.seed(:name, :parent_id,
  {name: 'Leitungsteam',
   parent_id: zhshgl.id}
)[0]

Group::MitgliederorganisationGremium.seed(:name, :parent_id,
  {name: 'Beirat',
   parent_id: zhshgl.id}
)[0]


zuerich, oberland, emmental = Group::Sektion.seed(:name, :parent_id,
  {name: 'Zürich',
   parent_id: zhshgl.id},

  {name: 'Oberland',
   parent_id: zhshgl.id},

  {name: 'Emmental',
   parent_id: be.id}
)


stadtzh, jona, hintereff, burgdorf = Group::Ortsgruppe.seed(:name, :parent_id,
  {name: 'Stadt Zürich',
   parent_id: zuerich.id},

  {name: 'Jona',
   parent_id: zuerich.id},

  # Ortsgruppe without Sektion
  {name: 'Hintereffretikon',
   parent_id: zhshgl.id},

  {name: 'Burgdorf',
   parent_id: emmental.id}
)


vereine = Group::Verein.seed(:name, :parent_id,
  {name: 'Verein Cevi Zürich',
   parent_id: stadtzh.id}
)


jungschar_altst, jungschar_zh10, jungschar_burgd = Group::Jungschar.seed(:name, :parent_id,
  {name: 'Altstetten-Albisrieden',
   parent_id: stadtzh.id},

  {name: 'Zürich 10',
   parent_id: stadtzh.id},

  {name: 'Burgdorf',
   parent_id: burgdorf.id}

)

jungschar_altst_0405, jungschar_altst_0203 = Group::Stufe.seed(:name, :parent_id,
  {name: 'Jahrgang 04/05',
   parent_id: jungschar_altst.id},
  {name: 'Jahrgang 02/03',
   parent_id: jungschar_altst.id}
)

Group::Gruppe.seed(:name, :parent_id,
  {name: 'Ammon',
   parent_id: jungschar_altst_0405.id},
  {name: 'Genesis',
   parent_id: jungschar_altst_0405.id},
  {name: 'Masada',
   parent_id: jungschar_altst_0203.id}
)


Group::Froeschli.seed(:name, :parent_id,
  {name: 'Fröschli',
   parent_id: jungschar_zh10.id}
)

Group::Stufe.seed(:name, :parent_id,
  {name: 'Aranda',
   parent_id: jungschar_zh10.id},

  {name: 'Jakob',
   parent_id: jungschar_zh10.id},

  {name: 'Salomo',
   parent_id: jungschar_zh10.id},

  {name: 'Samson',
   parent_id: jungschar_zh10.id},

  {name: 'Sinai',
   parent_id: jungschar_zh10.id},

  {name: 'Zephanja',
   parent_id: jungschar_zh10.id},

  {name: 'Zion',
   parent_id: jungschar_zh10.id}
)

Group::JungscharTeam.seed(:name, :parent_id,
  {name: 'Leitungsteam',
   parent_id: jungschar_zh10.id}
)

Group::JungscharExterne.seed(:name, :parent_id,
  {name: 'Cevi-E',
   parent_id: jungschar_zh10.id},
  {name: 'Räumlichkeit',
   parent_id: jungschar_zh10.id}
)


Group::Stufe.seed(:name, :parent_id,
  {name: 'Paprika',
   parent_id: jungschar_burgd.id},

  {name: 'Wildsau',
   parent_id: jungschar_burgd.id},

  {name: 'Tiger',
   parent_id: jungschar_burgd.id}
)

Group::JungscharTeam.seed(:name, :parent_id,
  {name: 'Leitungsteam',
   parent_id: jungschar_burgd.id}
)


tensing = Group::TenSing.seed(:name, :parent_id,
  {name: 'Seebach',
   parent_id: stadtzh.id}
)[0]

Group::TenSingTeamGruppe.seed(:name, :parent_id,
  {name: 'Leitungsteam',
   parent_id: tensing.id}
)


sport = Group::Sport.seed(:name, :parent_id,
  {name: 'Cevi Zürich Sport',
   parent_id: stadtzh.id}
)[0]

Group::SportTeamGruppe.seed(:name, :parent_id,
  {name: 'Mannschaft A',
   parent_id: sport.id},
  {name: 'Mannschaft B',
   parent_id: sport.id}
)


lernhilfe, kino = Group::WeitereArbeitsgebiete.seed(:name, :parent_id,
  {name: 'Cevi Lernhilfe',
   parent_id: stadtzh.id},

  {name: 'Cevi Kino',
   parent_id: stadtzh.id}
)

Group::WeitereArbeitsgebieteTeamGruppe.seed(:name, :parent_id,
  {name: 'Lehrpersonen',
   parent_id: lernhilfe.id}
)

Group::WeitereArbeitsgebieteExterne.seed(:name, :parent_id,
  {name: 'Schüler/-innen',
   parent_id: lernhilfe.id}
)

Group.rebuild!
