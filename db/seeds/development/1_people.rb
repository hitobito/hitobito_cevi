# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
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
  'Andre Kunz',
  'Andreas Maierhofer',
  'Bruno Santschi',
  'Mathis Hofer',
  'Matthias Viehweger',
  'Pascal Zumkehr',
  'Pierre Fritsch',
  'Roland Studer',
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

cevi_emails = %w(zora@cevi.ch
  simba.uster@cevi.ch
  lb@blattertech.ch
  carbon@cevi.ch
  adler@cevi-dinhard.ch
  ursina.gubler@cevi.ch
  christian.rahm@cevi.ch
  calvin.h@cevi.ws
  leu@cevi.ws
  lanu.rl@cevi.ws
  tuemi@cevi.ch
  info@thomashaefliger.ch)

cevi_password = BCrypt::Password.create("cevi14cevi", cost: 1)
cevi_emails.each do |email|
  role_type = Group::Dachverband::Administrator
  attrs = seeder.person_attributes(role_type).merge(email: email,
                                                     encrypted_password: cevi_password )
  Person.seed_once(:email, attrs)
  person = Person.find_by_email(attrs[:email])
  role_attrs = { person_id: person.id, group_id: root.id, type: role_type.sti_name }
  Role.seed_once(*role_attrs.keys, role_attrs)
end
