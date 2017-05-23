# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'


describe PersonAbility do

  subject { ability }
  let(:ability) { Ability.new(role.person.reload) }


  context :update do
    let(:group) { Fabricate(Group::MitgliederorganisationSpender.name, parent: groups(:zhshgl)) }
    let(:spender) { Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: group).person }

    context 'upper layer' do
      context 'layer admin' do
        let(:role) { Fabricate(Group::Dachverband::Administrator.name, group: groups(:dachverband)) }

        it 'may not update spender' do
          is_expected.not_to be_able_to(:update, spender)
        end
      end

      context 'layer finance' do
        let(:role) { Fabricate(Group::DachverbandGeschaeftsstelle::Finanzverantwortlicher.name, group: groups(:dachverband_gs)) }

        it 'may not update spender' do
          is_expected.not_to be_able_to(:update, spender)
        end
      end
    end

    context 'same layer' do
      context 'layer admin' do
        let(:role) { Fabricate(Group::Mitgliederorganisation::Administrator.name, group: groups(:zhshgl)) }

        it 'may not update spender' do
          is_expected.not_to be_able_to(:update, spender)
        end
      end

      context 'layer finance' do
        let(:role) { Fabricate(Group::MitgliederorganisationGeschaeftsstelle::Finanzverantwortlicher.name, group: groups(:zhshgl_gs)) }

        it 'may update spender' do
          is_expected.to be_able_to(:update, spender)
        end
      end
    end

    context 'group full' do
      let(:role) { Fabricate(Group::MitgliederorganisationSpender::SpendenVerwalter.name, group: group) }

      it 'group full may update spender' do
        is_expected.to be_able_to(:update, spender)
      end
    end

    context 'event organizer' do
      context 'layer_and_below_full' do
        context 'in event group' do
         let(:role) { Fabricate(Group::Jungschar::Abteilungsleiter.name, group: groups(:jungschar_altst)) }

          it 'may update people participating in organized events' do
            event = Fabricate(:event, groups: [role.group])
            person = Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_burgd_paprika)).person

            is_expected.not_to be_able_to(:update, person.reload)

            Fabricate(:event_participation, event: event, person: person)
            is_expected.to be_able_to(:update, person.reload)
          end
        end

        context 'in event layer' do
          let(:role) { Fabricate(Group::MitgliederorganisationGeschaeftsstelle::Geschaeftsleiter.name, group: groups(:zhshgl_gs)) }

          it 'may update people participating in organized events' do
            event = Fabricate(:event, groups: [groups(:zhshgl_beirat)])
            person = Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_burgd_paprika)).person

            is_expected.not_to be_able_to(:update, person.reload)

            Fabricate(:event_participation, event: event, person: person)
            is_expected.to be_able_to(:update, person.reload)
          end
        end

        context 'in course layer' do
          let(:role) { Fabricate(Group::MitgliederorganisationGeschaeftsstelle::Geschaeftsleiter.name, group: groups(:zhshgl_gs)) }

          it 'may update people participating in organized events' do
            event = Fabricate(:course, groups: [groups(:zhshgl)], application_contact: role.group)
            person = Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_burgd_paprika)).person

            is_expected.not_to be_able_to(:update, person.reload)

            Fabricate(:event_participation, event: event, person: person)
            is_expected.to be_able_to(:update, person.reload)
          end
        end
      end

      context 'group_and_below_full' do
        let(:role) { Fabricate(Group::Stufe::Stufenleiter.name, group: groups(:jungschar_zh10_aranda)) }

        it 'may update people participating in organized events' do
          event = Fabricate(:event, groups: [role.group, groups(:jungschar_burgd_paprika)])
          person = Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_burgd_paprika)).person

          is_expected.not_to be_able_to(:update, person.reload)

          Fabricate(:event_participation, event: event, person: person)
          is_expected.to be_able_to(:update, person.reload)
        end

        it 'may not update people participating in other events' do
          event = Fabricate(:event, groups: [groups(:jungschar_burgd_paprika)])
          person = Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_burgd_paprika)).person
          Fabricate(:event_participation, event: event, person: person)
          # user also has a non-permitting role in organizing group
          Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_burgd_paprika), person: role.person)

          expect(Ability.new(role.person.reload)).not_to be_able_to(:update, person.reload)
        end
      end
    end

    context 'event leader' do
      let(:role) { Fabricate(Group::Jungschar::Abteilungsleiter.name, group: groups(:jungschar_altst)) }

      it 'may update people participating in leaded events' do
        event = Fabricate(:event, groups: [groups(:zuerich)])
        person = Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_burgd_paprika)).person
        Fabricate(:event_participation, event: event, person: person)

        is_expected.not_to be_able_to(:update, person.reload)

        participation = Fabricate(:event_participation, event: event, person: role.person)
        Fabricate(Event::Role::Leader.name, participation: participation)

        expect(Ability.new(role.person.reload)).to be_able_to(:update, person.reload)
      end

      it 'may not update people participating in other events' do
        event1 = Fabricate(:event, groups: [groups(:zuerich)])
        event2 = Fabricate(:event, groups: [groups(:zuerich)])
        person = Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_burgd_paprika)).person
        Fabricate(:event_participation, event: event1, person: person)

        participation = Fabricate(:event_participation, event: event2, person: role.person)
        Fabricate(Event::Role::Leader.name, participation: participation)
        role.person.reload

        expect(Ability.new(role.person.reload)).not_to be_able_to(:update, person.reload)
      end
    end
  end

  context :unconfined_below do
    let(:role) { Fabricate(Group::MitgliederorganisationGeschaeftsstelle::AdminOrtsgruppen.name.to_sym, group: groups(:zhshgl_gs)) }

    it 'may view any non-visible in lower layers' do
      other = Fabricate(Group::Stufe::Teilnehmer.name.to_sym, group: groups(:jungschar_altst_0405))
      is_expected.to be_able_to(:show, other.person.reload)
      is_expected.to be_able_to(:show_full, other.person)
      is_expected.to be_able_to(:update, other.person)
      is_expected.to be_able_to(:update, other)
      is_expected.to be_able_to(:destroy, other)
      is_expected.to be_able_to(:create, other)
    end

    it 'may index groups in lower layer' do
      is_expected.to be_able_to(:index_people, groups(:jungschar_altst_0405))
      is_expected.to be_able_to(:index_full_people, groups(:jungschar_altst_0405))
      is_expected.to be_able_to(:index_local_people, groups(:jungschar_altst_0405))
    end

    it 'may not view any non-visible in other layers' do
      other = Fabricate(Group::Stufe::Teilnehmer.name.to_sym, group: groups(:jungschar_burgd_wildsau))
      is_expected.not_to be_able_to(:show, other.person.reload)
      is_expected.not_to be_able_to(:show_full, other.person)
      is_expected.not_to be_able_to(:update, other.person)
      is_expected.not_to be_able_to(:update, other)

      is_expected.not_to be_able_to(:index_local_people, groups(:jungschar_burgd_wildsau))
    end

  end

  context :layer_and_below_full do
    let(:role) { Fabricate(Group::Dachverband::Administrator.name.to_sym, group: groups(:dachverband)) }

    it 'may not view any non-visible in lower layers' do
      other = Fabricate(Group::Stufe::Teilnehmer.name.to_sym, group: groups(:jungschar_burgd_wildsau))
      is_expected.not_to be_able_to(:show_full, other.person.reload)
      is_expected.not_to be_able_to(:update, other.person)
      is_expected.not_to be_able_to(:update, other)
      is_expected.not_to be_able_to(:destroy, other)
      is_expected.not_to be_able_to(:create, other)
    end

    it 'may index groups in lower layer' do
      is_expected.to be_able_to(:index_people, groups(:jungschar_burgd_wildsau))
      is_expected.to be_able_to(:index_full_people, groups(:jungschar_burgd_wildsau))
      is_expected.not_to be_able_to(:index_local_people, groups(:jungschar_burgd_wildsau))
    end
  end

  context :update_old_data do

    roles = [Group::MitgliederorganisationGeschaeftsstelle::Geschaeftsleiter,
             Group::MitgliederorganisationGeschaeftsstelle::Angestellter,
             Group::MitgliederorganisationGeschaeftsstelle::Finanzverantwortlicher]

    [{ context: 'in same layer',
       target_role: Group::Mitgliederorganisation::Administrator,
       target_group: :zhshgl,
       roles_results: [true, true, false]
     },
     { context: 'in layer below',
       target_role: Group::Ortsgruppe::AdministratorCeviDB,
       target_group: :stadtzh,
       roles_results: [true, true, false]
     },
     { context: 'in another layer',
       target_role: Group::Ortsgruppe::AdministratorCeviDB,
       target_group: :burgdorf,
       roles_results: [false, false, false]
     }].each do |data|
      context data[:context] do
        let(:person) { Fabricate(data[:target_role].name, group: groups(data[:target_group])).person }

        data[:roles_results].each_with_index do |result, i|
          context 'as ' + roles[i].name.demodulize do
            let(:role) { Fabricate(roles[i].name, group: groups(:zhshgl_gs)) }

            if result
              it 'is allowed' do
                is_expected.to be_able_to(:update_old_data, person)
              end
            else
              it 'is not allowed' do
                is_expected.not_to be_able_to(:update_old_data, person)
              end
            end
          end
        end
      end
    end

  end

end
