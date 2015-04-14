require 'spec_helper'

describe PersonAccessibles do
  [:index, :layer_search, :deep_search, :global].each do |action|
    context action do
      let(:user)   { role.person.reload }
      let(:ability) { PersonAccessibles.new(user, action == :index ? group : nil) }

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
          let(:group) { Fabricate(Group::Mitgliederorganisation::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }

          it 'may not get spender people' do
            other = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: group)
            is_expected.not_to include(other.person)
          end
        end
      end

      describe 'layer_and_below_full on same layer' do
        let(:role) { Fabricate(Group::Mitgliederorganisation::Administrator.name, group: groups(:zhshgl)) }


        context 'lower spender group' do
          let(:group) { Fabricate(Group::Mitgliederorganisation::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }

          it 'may not get spender people' do
            other = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: group)
            is_expected.not_to include(other.person)
          end
        end
      end

      describe 'financials on same layer' do
        let(:role) { Fabricate(Group::MitgliederorganisationGeschaeftsstelle::Finanzverantwortlicher.name, group: groups(:zhshgl_gs)) }

        context 'lower spender group' do
          let(:group) { Fabricate(Group::Mitgliederorganisation::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }

          it 'may get spender people' do
            other = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: group)
            is_expected.to include(other.person)
          end
        end
      end

      describe 'group full in same group' do
        let(:role) { Fabricate(Group::MitgliederorganisationSpender::SpendenVerwalter.name, group: group) }

        context 'lower spender group' do
          let(:group) { Fabricate(Group::Mitgliederorganisation::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }

          it 'may get spender people' do
            other = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: group)
            is_expected.to include(other.person)
          end
        end
      end
    end
  end
end
