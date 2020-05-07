# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe PeopleController do

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
