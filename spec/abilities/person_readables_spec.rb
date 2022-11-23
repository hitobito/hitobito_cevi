# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe PersonReadables do

  [:index, :layer_search, :deep_search, :global].each do |action|
    context action do
      let(:user)   { role.person.reload }
      let(:ability) { PersonReadables.new(user, action == :index ? group : nil) }

      let(:all_accessibles) do
        people = Person.accessible_by(ability)
        case action
        when :index then people
        when :layer_search then people.in_layer(group.layer_group)
        when :deep_search then people.in_or_below(group.layer_group)
        when :global then people
        end
      end

      subject { all_accessibles }

      describe 'layer_and_below_full on upper layer' do
        let(:role) { Fabricate(Group::Dachverband::Administrator.name, group: groups(:dachverband)) }

        it 'has layer and below full permission' do
          expect(role.permissions).to include(:layer_and_below_full)
        end

        context 'lower spender group' do
          let(:group) { Fabricate(Group::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }

          it 'may not get spender people' do
            other = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: group)
            is_expected.not_to include(other.person)
          end
        end

        context 'lower stufe group' do
          let(:group) { groups(:jungschar_altst_0405) }

          it 'may not get non-visible people' do
            other = Fabricate(Group::Stufe::Teilnehmer.name, group: group)
            is_expected.not_to include(other.person)
          end
        end
      end

      describe 'layer_and_below_full on same layer' do
        let(:role) { Fabricate(Group::Mitgliederorganisation::Administrator.name, group: groups(:zhshgl)) }


        context 'spender group' do
          let(:group) { Fabricate(Group::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }

          it 'may not get spender people' do
            other = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: group)
            is_expected.not_to include(other.person)
          end
        end
      end

      describe 'unconfined_below on upper layer' do
        let(:role) { Fabricate(Group::MitgliederorganisationGeschaeftsstelle::AdminOrtsgruppen.name, group: groups(:zhshgl_gs)) }

        it 'has layer and below full permission' do
          expect(role.permissions).to include(:unconfined_below)
        end

        context 'lower spender group' do
          let(:group) { Fabricate(Group::JungscharSpender.name, parent: groups(:jungschar_altst)) }

          it 'may get spender people' do
            other = Fabricate(Group::JungscharSpender::Spender.name, group: group)
            is_expected.to include(other.person)
          end
        end

        context 'lower stufe group' do
          let(:group) { groups(:jungschar_altst_0405) }

          it 'may get non-visible people' do
            other = Fabricate(Group::Stufe::Teilnehmer.name, group: group)
            is_expected.to include(other.person)
          end
        end
      end

      describe 'unconfined_below on same layer' do
        let(:role) { Fabricate(Group::MitgliederorganisationGeschaeftsstelle::AdminOrtsgruppen.name, group: groups(:zhshgl_gs)) }

        context 'spender group' do
          let(:group) { Fabricate(Group::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }

          it 'may get spender people' do
            other = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: group)
            is_expected.to include(other.person)
          end
        end
      end

      describe 'financials on same layer' do
        let(:role) { Fabricate(Group::MitgliederorganisationGeschaeftsstelle::Finanzverantwortlicher.name, group: groups(:zhshgl_gs)) }

        context 'lower spender group' do
          let(:group) { Fabricate(Group::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }

          it 'may get spender people' do
            other = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: group)
            is_expected.to include(other.person)
          end
        end
      end

      describe 'group and below full in same group' do
        let(:role) { Fabricate(Group::MitgliederorganisationSpender::SpendenVerwalter.name, group: group) }

        context 'lower spender group' do
          let(:group) { Fabricate(Group::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }

          it 'may get spender people' do
            other = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: group)
            is_expected.to include(other.person)
          end
        end
      end

      context 'using service_token' do
        describe 'with show_donors' do
          let(:user) { service_token.dynamic_user }
          let(:service_token) { Fabricate(:service_token, show_donors: true, layer: groups(:zhshgl)) }

          let(:group) { Fabricate(Group::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }

          it 'has show_donors' do
            expect(service_token.show_donors).to eq(true)
          end

          it 'may get spender people of spender group' do
            other = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: group)
            is_expected.to include(other.person)
          end
        end

        describe 'without show_donors' do
          let(:user) { service_token.dynamic_user }
          let(:service_token) { Fabricate(:service_token, show_donors: false, layer: groups(:zhshgl)) }

          let(:group) { Fabricate(Group::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }

          it 'does not have show_donors' do
            expect(service_token.show_donors).to eq(false)
          end


          it 'may not get spender people of spender group in same layer' do
            other = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: group)
            is_expected.to_not include(other.person)
          end
        end
      end
    end
  end
end
