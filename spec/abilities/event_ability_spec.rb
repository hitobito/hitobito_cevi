# encoding: utf-8

#  Copyright (c) 2012-2017, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'


describe EventAbility do

  let(:ability) { Ability.new(role.person.reload) }

  context 'Ausbildungsmitglied' do
    let(:role) { Fabricate(Group::MitgliederorganisationGremium::Ausbildungsmitglied.name.to_sym, group: groups(:zhshgl_beirat)) }

    it 'may index participants in same layer course' do
      expect(ability).to be_able_to(:index_participations, events(:top_course))
    end

    it 'may not index participants in same layer event' do
      expect(ability).not_to be_able_to(:index_participations, Fabricate(:event, groups: [groups(:zhshgl_beirat)]))
    end

    it 'may not index participants in lower layer event' do
      expect(ability).not_to be_able_to(:index_participations, Fabricate(:event, groups: [groups(:stadtzh)]))
    end

    it 'may not index participants in other layer course' do
      gs = Fabricate(Group::MitgliederorganisationGeschaeftsstelle.name.to_sym, parent: groups(:be))
      gremium = Fabricate(Group::MitgliederorganisationGremium.name.to_sym, parent: groups(:be))
      Fabricate(Group::MitgliederorganisationGremium::Mitglied.name.to_sym, group: gremium)
      expect(ability).not_to be_able_to(:index_participations, Fabricate(:course, groups: [groups(:be)], application_contact: gs))
    end
  end

  context 'AktiverKursleiter' do
    let(:role) { Fabricate(Group::MitgliederorganisationGremium::AktiverKursleiter.name.to_sym, group: groups(:zhshgl_beirat)) }

    it 'may not index participants in same layer course' do
      expect(ability).not_to be_able_to(:index_participations, events(:top_course))
    end
  end

end
