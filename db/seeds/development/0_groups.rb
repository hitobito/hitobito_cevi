# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require Rails.root.join('db', 'seeds', 'support', 'group_seeder')

@seeder = GroupSeeder.new

dachverband = Group.roots.first
srand(42)

def seed_group(group, *attrs)
  with_group_attributes = attrs.map { |attr| attr.merge(@seeder.group_attributes) }
  group.seed(:name, :parent_id, *with_group_attributes)
end

seed_group(Group::DachverbandVorstand, {
  name: 'Vorstand',
  parent_id: dachverband.id
})

seed_group(Group::DachverbandGeschaeftsstelle, {
  name: 'Geschäftsstelle',
  parent_id: dachverband.id
})

seed_group(Group::DachverbandGremium, {
  name: 'Revisionsstelle',
  parent_id: dachverband.id
})

zhshgl, be, alpin = seed_group(Group::Mitgliederorganisation,
  {name: 'Cevi Regionalverband ZH-SH-GL',
   short_name: 'RV ZH-SH-GL',
   address: 'Sihlstrasse 33',
   zip_code: 8021,
   town: 'Zürich',
   country: 'Schweiz',
   email: 'rv-zhshgl@example.com',
   parent_id: dachverband.id, },

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
  parent_id: dachverband.id})

[zhshgl, be, alpin].each do |s|
  @seeder.seed_social_accounts(s)
end

seed_group(Group::MitgliederorganisationVorstand, {
  name: 'Zentralvorstand',
  parent_id: zhshgl.id})

seed_group(Group::MitgliederorganisationGeschaeftsstelle, {
  name: 'Leitungsteam',
  parent_id: zhshgl.id})

seed_group(Group::MitgliederorganisationGremium, {
  name: 'Beirat',
  parent_id: zhshgl.id})


zuerich, oberland, emmental = seed_group(Group::Sektion,
  {name: 'Zürich',
   parent_id: zhshgl.id },

  {name: 'Oberland',
   parent_id: zhshgl.id},

  {name: 'Emmental',
   parent_id: be.id})


stadtzh, jona, hintereff, burgdorf = seed_group(Group::Ortsgruppe,
  {name: 'Stadt Zürich',
   parent_id: zuerich.id},

  {name: 'Jona',
   parent_id: zuerich.id},

  # Ortsgruppe without Sektion
  {name: 'Hintereffretikon',
   parent_id: zhshgl.id},

  {name: 'Burgdorf',
   parent_id: emmental.id})


seed_group(vereine = Group::Verein, {
  name: 'Verein Cevi Zürich',
  parent_id: stadtzh.id })


jungschar_altst, jungschar_zh10, jungschar_burgd = seed_group(Group::Jungschar,
  {name: 'Altstetten-Albisrieden',
   parent_id: stadtzh.id},

  {name: 'Zürich 10',
   parent_id: stadtzh.id},

  {name: 'Burgdorf',
   parent_id: burgdorf.id})

jungschar_altst_0405, jungschar_altst_0203 = seed_group(Group::Stufe,
  {name: 'Jahrgang 04/05',
   parent_id: jungschar_altst.id},
  {name: 'Jahrgang 02/03',
   parent_id: jungschar_altst.id})

seed_group(Group::Gruppe,
  {name: 'Ammon',
   parent_id: jungschar_altst_0405.id},
  {name: 'Genesis',
   parent_id: jungschar_altst_0405.id},
  {name: 'Masada',
   parent_id: jungschar_altst_0203.id})


seed_group(Group::Froeschli,
  {name: 'Fröschli',
   parent_id: jungschar_zh10.id})

seed_group(Group::Stufe,
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
   parent_id: jungschar_zh10.id})

seed_group(Group::JungscharTeam,
  {name: 'Leitungsteam',
   parent_id: jungschar_zh10.id})

seed_group(Group::JungscharExterne,
  {name: 'Cevi-E',
   parent_id: jungschar_zh10.id},
  {name: 'Räumlichkeit',
   parent_id: jungschar_zh10.id})


seed_group(Group::Stufe,
  {name: 'Paprika',
   parent_id: jungschar_burgd.id},

  {name: 'Wildsau',
   parent_id: jungschar_burgd.id},

  {name: 'Tiger',
   parent_id: jungschar_burgd.id})

seed_group(Group::JungscharTeam,
  {name: 'Leitungsteam',
   parent_id: jungschar_burgd.id})


tensing = seed_group(Group::TenSing,
  {name: 'Seebach',
   parent_id: stadtzh.id})[0]

seed_group(Group::TenSingTeamGruppe,
  {name: 'Leitungsteam',
   parent_id: tensing.id})


sport = seed_group(Group::Sport,
  {name: 'Cevi Zürich Sport',
   parent_id: stadtzh.id})[0]

seed_group(Group::SportTeamGruppe,
  {name: 'Mannschaft A',
   parent_id: sport.id},
  {name: 'Mannschaft B',
   parent_id: sport.id})


lernhilfe, kino = seed_group(Group::WeitereArbeitsgebiete,
  {name: 'Cevi Lernhilfe',
   parent_id: stadtzh.id},

  {name: 'Cevi Kino',
   parent_id: stadtzh.id})

seed_group(Group::WeitereArbeitsgebieteTeamGruppe,
  {name: 'Lehrpersonen',
   parent_id: lernhilfe.id})

seed_group(Group::WeitereArbeitsgebieteExterne,
  {name: 'Schüler/-innen',
   parent_id: lernhilfe.id})

Group.rebuild!
