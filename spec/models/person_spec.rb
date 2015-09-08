# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe Person do

  context 'PUBLIC ATTRS' do
    it 'contains parent fields' do
      expect(Person::PUBLIC_ATTRS).to include(:salutation_parents)
      expect(Person::PUBLIC_ATTRS).to include(:name_parents)
    end
  end

  context 'canton_value' do

    it 'is blank for nil value' do
      expect(Person.new.canton_value).to be_blank
    end

    it 'is blank for blank value' do
      expect(Person.new(canton: '').canton_value).to be_blank
    end

    it 'is locale specific value for valid key' do
      expect(Person.new(canton: 'be').canton_value).to eq 'Bern'
    end
  end

  context '#possible_ortsgruppen' do
    let(:person) { Fabricate(:person, roles: []) }

    it 'returns empty array if no ortsgruppe is in groups hierarchy' do
      Fabricate(Group::Dachverband::Administrator.name.to_sym,
                group: groups(:dachverband), person: person)
      expect(person.possible_ortsgruppen).to eq([])
    end

    it 'returns all ortsgruppen in groups hierarchy' do
      Fabricate(Group::Dachverband::Administrator.name.to_sym,
                group: groups(:dachverband), person: person)
      Fabricate(Group::Jungschar::Abteilungsleiter.name.to_sym,
                group: groups(:jungschar_zh10), person: person)
      Fabricate(Group::Jungschar::Abteilungsleiter.name.to_sym,
                group: groups(:jungschar_burgd), person: person)
      expect(person.reload.possible_ortsgruppen).to eq([groups(:stadtzh), groups(:burgdorf)])
    end

    it 'eliminates redundant ortsgruppen' do
      Fabricate(Group::Dachverband::Administrator.name.to_sym,
                group: groups(:dachverband), person: person)
      Fabricate(Group::Jungschar::Abteilungsleiter.name.to_sym,
                group: groups(:jungschar_zh10), person: person)
      Fabricate(Group::Jungschar::Abteilungsleiter.name.to_sym,
                group: groups(:jungschar_altst), person: person)
      Fabricate(Group::Jungschar::Abteilungsleiter.name.to_sym,
                group: groups(:jungschar_burgd), person: person)
      expect(person.reload.possible_ortsgruppen).to eq([groups(:stadtzh), groups(:burgdorf)])
    end
  end

end
