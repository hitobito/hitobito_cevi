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

puzzlers = ['Pascal Zumkehr',
            'Pierre Fritsch',
            'Andreas Maierhofer',
            'Andre Kunz',
            'Roland Studer',
            'Mathis Hofer']

devs = {}
puzzlers.each do |puz|
  devs[puz] = "#{puz.split.last.downcase}@puzzle.ch"
end

seeder = CeviPersonSeeder.new

seeder.seed_all_roles

root = Group.root
devs.each do |name, email|
  seeder.seed_developer(name, email, root, Group::DachverbandGeschaeftsstelle::Angestellter)
end
