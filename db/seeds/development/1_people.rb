# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require Rails.root.join('db', 'seeds', 'support', 'person_seeder')

class CeviPersonSeeder < PersonSeeder

  def amount(role_type)
    case role_type.name.demodulize
    when 'Mitglied', 'Helfer', 'Teilnehmer' then 5
    else 1
    end
  end

end

puzzlers = [
  'Andreas Maierhofer',
  'Bruno Santschi',
  'Mathis Hofer',
  'Matthias Viehweger',
  'Pascal Zumkehr'
]

devs = {}
puzzlers.each do |puz|
  devs[puz] = "#{puz.split.last.downcase}@puzzle.ch"
end

seeder = CeviPersonSeeder.new

seeder.seed_all_roles

root = Group.root
devs.each do |name, email|
  seeder.seed_developer(name, email, root, Group::Dachverband::Administrator)
end

seeder.assign_role_to_root(root, Group::Dachverband::Administrator)

cevi_emails = %w(
  carbon@cevi.ch
  louis.siegrist@cevi.ch
  zottel@cevi.ch
  calvin.h@cevi.ws
  luchs@cevimail.ch)

cevi_emails.each do |email|
  role_type = Group::Dachverband::Administrator
  attrs = seeder.person_attributes(role_type).merge(email: email)
  Person.seed_once(:email, attrs)
  person = Person.find_by_email(attrs[:email])
  role_attrs = { person_id: person.id, group_id: root.id, type: role_type.sti_name }
  Role.seed_once(*role_attrs.keys, role_attrs)
end
