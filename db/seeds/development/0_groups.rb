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
   short_name: 'CEVI'}.merge(seeder.group_attributes)
)[0]

dv_vorstand = Group::DachverbandVorstand.seed(:name, :parent_id,
  {name: 'Vorstand',
   parent_id: dachverband.id}.merge(seeder.group_attributes)
)[0]

dv_geschaeftsst = Group::DachverbandGeschaeftsstelle.seed(:name, :parent_id,
  {name: 'Geschäftsstelle',
   parent_id: dachverband.id}.merge(seeder.group_attributes)
)[0]

dv_gremium = Group::DachverbandGremium.seed(:name, :parent_id,
  {name: 'Revisionsstelle',
   parent_id: dachverband.id}.merge(seeder.group_attributes)
)[0]

orgs = Group::Mitgliederorganisation.seed(:name, :parent_id,
  {name: 'Cevi Regionalverband ZH-SH-GL',
   # short_name: 'RV ZH-SH-GL',
   # address: 'Sihlstrasse 33',
   # zip_code: 8021,
   # town: 'Zürich',
   # country: 'Schweiz',
   # email: 'rv-zhshgl@example.com',
   parent_id: dachverband.id}.merge(seeder.group_attributes),

  {name: 'Cevi Region Bern',
   # short_name: 'RV BE',
   # address: 'Rabbentalstrasse 69',
   # zip_code: 3013,
   # town: 'Bern',
   # country: 'Schweiz',
   # email: 'rv-bern@example.com',
   parent_id: dachverband.id}.merge(seeder.group_attributes),

  {name: 'Cevi Alpin',
   # short_name: 'AG ALP',
   # address: 'Ausser Dorf 2',
   # zip_code: 7260,
   # town: 'Davos',
   # country: 'Schweiz',
   # email: 'alpin@example.com',
   parent_id: dachverband.id}.merge(seeder.group_attributes),

)

orgs.each do |s|
  seeder.seed_social_accounts(s)
end

mo_vorstand = Group::MitgliederorganisationVorstand.seed(:name, :parent_id,
  {name: 'Zentralvorstand',
   parent_id: orgs[0].id}.merge(seeder.group_attributes)
)[0]

mo_leitungsteam = Group::MitgliederorganisationGeschaeftsstelle.seed(:name, :parent_id,
  {name: 'Leitungsteam',
   parent_id: orgs[0].id}.merge(seeder.group_attributes)
)[0]

mo_beirat = Group::MitgliederorganisationGremium.seed(:name, :parent_id,
  {name: 'Beirat',
   parent_id: orgs[0].id}.merge(seeder.group_attributes)
)[0]

sektionen = Group::Sektion.seed(:name, :parent_id,
  {name: 'Zürich',
   parent_id: orgs[0].id},

  {name: 'Oberland',
   parent_id: orgs[0].id}
)

ortsgruppen = Group::Ortsgruppe.seed(:name, :parent_id,
  {name: 'Stadt Zürich',
   parent_id: sektionen[0].id}.merge(seeder.group_attributes),

  {name: 'Jona',
   parent_id: sektionen[0].id}.merge(seeder.group_attributes),

  # Ortsgruppe without Sektion
  {name: 'Hintereffretikon',
   parent_id: orgs[0].id}.merge(seeder.group_attributes)
)


vereine = Group::Verein.seed(:name, :parent_id,
  {name: 'Verein Cevi Zürich',
   parent_id: ortsgruppen[0].id}.merge(seeder.group_attributes)
)


jungscharen = Group::Jungschar.seed(:name, :parent_id,
  {name: 'Altstetten-Albisrieden',
   parent_id: ortsgruppen[0].id}.merge(seeder.group_attributes),

  {name: 'Zürich 10',
   parent_id: ortsgruppen[0].id}.merge(seeder.group_attributes)
)


stufen_altalb = Group::Stufe.seed(:name, :parent_id,
  {name: 'Jahrgang 04/05',
   parent_id: jungscharen[0].id},
  {name: 'Jahrgang 02/03',
   parent_id: jungscharen[0].id}
)

gruppen_altalb = Group::Gruppe.seed(:name, :parent_id,
  {name: 'Ammon',
   parent_id: stufen_altalb[0].id},
  {name: 'Genesis',
   parent_id: stufen_altalb[0].id},
  {name: 'Masada',
   parent_id: stufen_altalb[1].id}
)


froeschli_zh10 = Group::Froeschli.seed(:name, :parent_id,
  {name: 'Fröschli',
   parent_id: jungscharen[1].id}
)

stufen_zh10 = Group::Stufe.seed(:name, :parent_id,
  {name: 'Aranda',
   parent_id: jungscharen[1].id},

  {name: 'Jona',
   parent_id: jungscharen[1].id},

  {name: 'Salomo',
   parent_id: jungscharen[1].id},

  {name: 'Samson',
   parent_id: jungscharen[1].id},

  {name: 'Sinai',
   parent_id: jungscharen[1].id},

  {name: 'Zephanja',
   parent_id: jungscharen[1].id},

  {name: 'Zion',
   parent_id: jungscharen[1].id}
)

teams_zh10 = Group::Stufe.seed(:name, :parent_id,
  {name: 'Leitungsteam',
   parent_id: jungscharen[1].id}
)

externe_zh10 = Group::Stufe.seed(:name, :parent_id,
  {name: 'Cevi-E',
   parent_id: jungscharen[1].id},
  {name: 'Räumlichkeit',
   parent_id: jungscharen[1].id}
)


tensings = Group::TenSing.seed(:name, :parent_id,
  {name: 'Seebach',
   parent_id: ortsgruppen[0].id}.merge(seeder.group_attributes)
)

gruppen_seebach = Group::TenSingTeamGruppe.seed(:name, :parent_id,
  {name: 'Leitungsteam',
   parent_id: tensings[0].id}
)


sport = Group::Sport.seed(:name, :parent_id,
  {name: 'Cevi Zürich Sport',
   parent_id: ortsgruppen[0].id}.merge(seeder.group_attributes)
)

gruppen_sport = Group::SportTeamGruppe.seed(:name, :parent_id,
  {name: 'Mannschaft A',
   parent_id: sport[0].id},
  {name: 'Mannschaft B',
   parent_id: sport[0].id}
)


wags = Group::WeitereArbeitsgebiete.seed(:name, :parent_id,
  {name: 'Cevi Lernhilfe',
   parent_id: ortsgruppen[0].id}.merge(seeder.group_attributes),

  {name: 'Cevi Kino',
   parent_id: ortsgruppen[0].id}.merge(seeder.group_attributes)
)

teams_lernhilfe = Group::WeitereArbeitsgebieteTeamGruppe.seed(:name, :parent_id,
  {name: 'Lehrpersonen',
   parent_id: wags[0].id}
)

teams_lernhilfe = Group::WeitereArbeitsgebieteExterne.seed(:name, :parent_id,
  {name: 'Schüler/-innen',
   parent_id: wags[0].id}
)

Group.rebuild!
