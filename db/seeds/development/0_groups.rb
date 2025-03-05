# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require Rails.root.join('db', 'seeds', 'support', 'group_seeder')

@seeder = GroupSeeder.new

def seed_group(group, *attrs)
  with_group_attributes = attrs.map {
    |attr| attr.merge(@seeder.group_attributes)
  }
  group.seed(:name, :parent_id, *with_group_attributes)
end

#
# Init Root Level
#
dachverband = Group.roots.first
srand(42)

seed_group(Group::DachverbandGremium, {
  name: 'Fachgruppen',
  parent_id: dachverband.id
})

seed_group(Group::DachverbandGeschaeftsstelle, {
  name: 'Geschäftsstelle',
  parent_id: dachverband.id
})

seed_group(Group::DachverbandExterne, {
  name: 'Mitarbeitende',
  parent_id: dachverband.id
})

seed_group(Group::DachverbandVorstand, {
  name: 'Vorstand',
  parent_id: dachverband.id
})

reg_agsoluzg, alpin, extkurse, reg_be, reg_ws, reg_zh = seed_group(Group::Mitgliederorganisation, {
  name: 'Regionalverband AG-SO-LU-ZG',
  short_name: 'AG-SO-LU-ZG',
  parent_id: dachverband.id
},
{
  name: 'Cevi Alpin',
  short_name: 'Cevi Alpin',
  parent_id: dachverband.id
},
{
  name: 'Externe Kursen',
  short_name: 'Externe Kursen',
  parent_id: dachverband.id
},

{
  name: 'Region Bern',
  short_name: 'Region Bern',
  street: 'Rabbentalstrasse',
  housenumber:  69,
  zip_code: 3013,
  town: 'Bern',
  country: 'Schweiz',
  parent_id: dachverband.id
},
{
  name: 'RV Winterthur-Schaffhausen',
  short_name: 'Region WS',
  street: 'Stadthausstrasse',
  housenumber: 103,
  zip_code: 8400,
  town: 'Winterthur',
  parent_id: dachverband.id
},
{
  name: 'Region Zürich',
  short_name: 'Region Zürich',
  street: 'Sihlstrasse',
  housenumber: 33,
  zip_code: 8021,
  town: 'Zürich',
  country: 'Schweiz',
  parent_id: dachverband.id
})

[alpin, reg_ws].each do |s|
  @seeder.seed_social_accounts(s)
end

#
# Init AG-SO-LU-ZG
#
seed_group(Group::MitgliederorganisationGremium, {
  name: 'Gremien',
  parent_id: reg_agsoluzg.id
})

seed_group(Group::MitgliederorganisationGeschaeftsstelle, {
  name: 'Seki',
  parent_id: reg_agsoluzg.id
})

seed_group(Group::MitgliederorganisationVorstand, {
  name: 'Vorstand',
  parent_id: reg_agsoluzg.id
})

ort_buro = seed_group(Group::Ortsgruppe, {
  name: 'Cevi Buchs-Rohr-Aarau',
  short_name: 'Cevi Buchs-Rohr-Aarau',
  parent_id: reg_agsoluzg.id
})

#
# Init Cevi Alpin
#
seed_group(Group::MitgliederorganisationGremium, {
  name: 'Bergführer',
  parent_id: alpin.id
})

seed_group(Group::MitgliederorganisationGeschaeftsstelle, {
  name: 'Hauptleiter',
  parent_id: alpin.id
})

seed_group(Group::MitgliederorganisationVorstand, {
  name: 'Vorstand',
  parent_id: alpin.id
})

#
# Init Ext Kurse
#
seed_group(Group::MitgliederorganisationGeschaeftsstelle, {
  name: 'Fiktive GS',
  parent_id: extkurse.id
})

#
# Init Region Bern
#
seed_group(Group::MitgliederorganisationExterne, {
  name: 'Externe',
  parent_id: reg_be.id
})

seed_group(Group::MitgliederorganisationGremium, {
  name: 'Gremien',
  parent_id: reg_be.id
})

seed_group(Group::MitgliederorganisationGeschaeftsstelle, {
  name: 'Sekretariat',
  parent_id: reg_be.id
})

seed_group(Group::MitgliederorganisationVorstand, {
  name: 'Vorstand',
  parent_id: reg_be.id
})

ort_aarwangen = seed_group(Group::Ortsgruppe, {
  name: 'Aarwangen',
  short_name: 'Aarwangen',
  parent_id: reg_be.id
})

#
# Init Region WS
#
seed_group(Group::MitgliederorganisationGremium, {
  name: 'Informatik',
  parent_id: reg_ws.id
})

seed_group(Group::MitgliederorganisationGeschaeftsstelle, {
  name: 'Sekretariat WS',
  short_name: 'Seki',
  parent_id: reg_ws.id
})

seed_group(Group::MitgliederorganisationVorstand, {
  name: 'Regionalleitung (Vorstand)',
  short_name: 'RL',
  parent_id: reg_ws.id
})

ort_andelfingen = seed_group(Group::Ortsgruppe, {
  name: 'Andelfingen',
  short_name: 'AND',
  parent_id: reg_ws.id
})

#
# Init Region Zürich
#
seed_group(Group::MitgliederorganisationGremium, {
  name: 'FG Informatik',
  parent_id: reg_zh.id
})

seed_group(Group::MitgliederorganisationGeschaeftsstelle, {
  name: 'Geschäftsstelle',
  parent_id: reg_zh.id
})

seed_group(Group::MitgliederorganisationVorstand, {
  name: 'Vorstand',
  parent_id: reg_zh.id
})

sek_oberland, sek_zuerich, sek_emmental = seed_group(Group::Sektion, {
  name: 'Sektion Oberland',
  parent_id: reg_zh.id
},
{
  name: 'Sektion Zürich',
  parent_id: reg_zh.id
})

ort_zh, ort_zh10, ort_zh11 = seed_group(Group::Ortsgruppe, {
  name: 'Cevi Zürich',
  short_name: 'Cevi Zürich',
  parent_id: sek_zuerich.id
},
{
  name: 'Zürich 10',
  short_name: 'Z10',
  parent_id: sek_zuerich.id
},
{
  name: 'Zürich 11',
  short_name: 'Z11',
  parent_id: sek_zuerich.id
})

seed_group(vereine = Group::Verein, {
  name: 'Verein Zürich',
  short_name: 'VER GLO',
  parent_id: ort_zh.id
})

jungschar_zh10, = seed_group(Group::Jungschar, {name: 'JS Zürich 10',
  parent_id: ort_zh.id
})

stufe_achaja = seed_group(Group::Stufe, {
  name: 'Achaja',
  parent_id: jungschar_zh10.id
},
{
  name: 'Aragaz',
  parent_id: jungschar_zh10.id
},
{
  name: 'Asharah',
  parent_id: jungschar_zh10.id
},
{
  name: 'Ephraim',
  parent_id: jungschar_zh10.id
})[0]

seed_group(Group::Gruppe, {
  name: 'Ammon',
  parent_id: stufe_achaja.id
},
{
  name: 'Genesis',
  parent_id: stufe_achaja.id
},
{
  name: 'Masada',
  parent_id: stufe_achaja.id
})

seed_group(Group::Froeschli, {
  name: 'Fröschli',
  parent_id: jungschar_zh10.id
})

seed_group(Group::JungscharTeam, {
  name: 'Leitungsteam',
  parent_id: jungschar_zh10.id
})

seed_group(Group::JungscharExterne, {
  name: 'Achaja Extern',
  parent_id: jungschar_zh10.id
},
{
  name: 'Aragaz Extern',
  parent_id: jungschar_zh10.id
})

sport = seed_group(Group::Sport, {
  name: 'Zürich 10 Sportgruppe',
  parent_id: jungschar_zh10.id
})[0]

tensing = seed_group(Group::TenSing, {
  name: 'Ten Sing Seebach',
  short_name: 'TS Seebach',
  parent_id: ort_zh11.id
})[0]

seed_group(Group::TenSingTeamGruppe, {
  name: 'Leitungsteam',
  parent_id: tensing.id
})

cevie, passivmitglieder = seed_group(Group::WeitereArbeitsgebiete, {
  name: 'Zürich 10 Cevi-E',
  parent_id: ort_zh.id
},
{
  name: 'Zürich 10 Passivmitglieder',
  parent_id: ort_zh.id
})

seed_group(Group::WeitereArbeitsgebieteExterne, {
  name: 'Ehemalige Passive',
  parent_id: passivmitglieder.id
})

Group.rebuild!
