# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe PeopleController do

  context 'cevi-specific permitted attributes' do
    let(:person) { Fabricate(Group::Ortsgruppe::AdministratorCeviDB.name, group: groups(:stadtzh)).person }
    let(:actor) do
      Fabricate(Group::MitgliederorganisationGeschaeftsstelle::Geschaeftsleiter.name,
                group: groups(:zhshgl_gs)).person
    end

    before { sign_in(actor) }

    it 'allows updating nationality' do
      put :update, params: { group_id: person.groups.first.id, id: person.id, person: { nationality: 'DE' } }
      expect(person.reload.nationality).to eq('DE')
    end

    it 'allows updating j_s_number' do
      put :update, params: { group_id: person.groups.first.id, id: person.id, person: { j_s_number: '12345' } }
      expect(person.reload.j_s_number).to eq('12345')
    end

    it 'allows updating salutation' do
      put :update, params: { group_id: person.groups.first.id, id: person.id, person: { salutation: 'formal' } }
      expect(person.reload.salutation).to eq('formal')
    end
  end

  context 'old_data' do
    let(:person) { Fabricate(Group::Ortsgruppe::AdministratorCeviDB.name, group: groups(:stadtzh)).person }

    before do
      sign_in(actor)
    end

    context 'as Geschaeftsleiter' do
      let(:actor) do
        Fabricate(Group::MitgliederorganisationGeschaeftsstelle::Geschaeftsleiter.name,
                  group: groups(:zhshgl_gs)).person
      end

      it 'can be updated' do
        put :update, params: { group_id: person.groups.first.id, id: person.id, person: { old_data: 'Lorem ipsum' } }
        expect(person.reload.old_data).to eq('Lorem ipsum')
      end
    end

    context 'as Finanzverantwortlicher' do
      let(:actor) do
        Fabricate(Group::MitgliederorganisationGeschaeftsstelle::Finanzverantwortlicher.name,
                  group: groups(:zhshgl_gs)).person
      end

      it 'cannot be updated' do
        put :update, params: { group_id: person.groups.first.id, id: person.id, person: { old_data: 'Lorem ipsum' } }
        expect(person.reload.old_data).to be_nil
      end
    end
  end

end
