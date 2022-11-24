# encoding: utf-8

#  Copyright (c) 2012-2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe PersonDecorator do

  let(:bulei)       { people(:bulei) }
  let(:dachverband) { groups(:dachverband) }

  let(:person)   { Fabricate(Group::Dachverband::Administrator.name, group: dachverband).person }
  let(:spender)  { Fabricate(Group::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }

  let(:decorator) { PersonDecorator.new(person.reload) }
  subject { decorator.roles_grouped }
  before do
    @spender_role = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: spender, person: person)
  end

  context 'as person' do

    before do
      sign_in(bulei)
    end

    context :bulei do
      it 'includes dachverband but not spender group' do
        expect(subject).to have_key(dachverband)
        expect(subject).not_to have_key(spender)
      end

      it 'includes SpendenVerwalter but not Spender role' do
        role = Fabricate(Group::MitgliederorganisationSpender::SpendenVerwalter.name, group: spender, person: person)
        expect(subject[spender]).to eq [role]
      end
    end

    context :spendenverwalter do
      before do
        Fabricate(Group::MitgliederorganisationSpender::SpendenVerwalter.name, group: spender, person: bulei)
      end

      it 'includes dachverband and spender group' do
        expect(subject).to have_key(dachverband)
        expect(subject).to have_key(spender)
      end

      it 'includes spender role for spender group' do
        expect(subject[spender]).to eq [@spender_role]
      end

      it 'includes SpendenVerwalter and Spender role' do
        role = Fabricate(Group::MitgliederorganisationSpender::SpendenVerwalter.name, group: spender, person: person)
        expect(subject[spender]).to match_array [role, @spender_role]
      end

      it 'includes nested spender group' do
        nested_spender = Fabricate(Group::MitgliederorganisationSpender.name, parent: spender)
        nested_spender_role = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: nested_spender, person: person)
        expect(subject[nested_spender]).to eq [nested_spender_role]
      end
    end

    context :dachverband_spendenverwalter do
      let(:dachverband_spender) { Fabricate(Group::DachverbandSpender.name, parent: dachverband) }

      before do
        Fabricate(Group::DachverbandSpender::SpendenVerwalter.name, group: dachverband_spender, person: bulei)
      end

      it 'includes dachverband but not spender group' do
        expect(subject).to have_key(dachverband)
        expect(subject).not_to have_key(spender)
      end
    end
  end

  context 'as service_token' do
    let(:service_token) { Fabricate(:service_token, groups: true, people: true, people_below: true, layer: groups(:zhshgl)) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(service_token.dynamic_user)
      allow_any_instance_of(ApplicationController).to receive(:current_service_token).and_return(service_token)
    end

    context 'without show_donors' do
      before { service_token.update(show_donors: false) }

      it 'includes dachverband but not spender group' do
        expect(subject).to have_key(dachverband)
        expect(subject).not_to have_key(spender)
      end

      it 'includes SpendenVerwalter but not Spender role' do
        role = Fabricate(Group::MitgliederorganisationSpender::SpendenVerwalter.name, group: spender, person: person)
        expect(subject[spender]).to eq [role]
      end
    end

    context 'with show_donors' do
      before do
        Fabricate(Group::MitgliederorganisationSpender::SpendenVerwalter.name, group: spender, person: bulei)
      end

      before { service_token.update(show_donors: true) }

      it 'includes dachverband and spender group' do
        expect(subject).to have_key(dachverband)
        expect(subject).to have_key(spender)
      end

      it 'includes spender role for spender group' do
        expect(subject[spender]).to eq [@spender_role]
      end

      it 'includes SpendenVerwalter and Spender role' do
        role = Fabricate(Group::MitgliederorganisationSpender::SpendenVerwalter.name, group: spender, person: person)
        expect(subject[spender]).to match_array [role, @spender_role]
      end

      it 'includes nested spender group' do
        nested_spender = Fabricate(Group::MitgliederorganisationSpender.name, parent: spender)
        nested_spender_role = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: nested_spender, person: person)
        expect(subject[nested_spender]).to eq [nested_spender_role]
      end
    end
  end
end
