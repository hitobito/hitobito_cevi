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
    before do
      @group = Fabricate(Group::Mitgliederorganisation::MitgliederorganisationSpender.name, parent: groups(:zhshgl))
      @spender = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: @group).person
    end

    context 'upper layer' do
      it 'layer admin may not update spender' do
        expect(ability(groups(:dachverband),
                Group::Dachverband::Administrator)).not_to be_able_to(:update, @spender)
      end

      it 'layer finance may not update spender' do
        expect(ability(groups(:dachverband_gs),
                Group::DachverbandGeschaeftsstelle::Finanzverantwortlicher)).not_to be_able_to(:update, @spender)
      end
    end


    context 'same layer' do
      it 'layer admin may not update spender' do
        expect(ability(groups(:zhshgl),
                Group::Mitgliederorganisation::Administrator)).not_to be_able_to(:update, @spender)
      end

      it 'layer finance may update spender' do
        expect(ability(groups(:zhshgl_gs),
                Group::MitgliederorganisationGeschaeftsstelle::Finanzverantwortlicher)).to be_able_to(:update, @spender)
      end
    end

    it 'group full may update spender' do
      expect(ability(@group,
              Group::MitgliederorganisationSpender::SpendenVerwalter)).to be_able_to(:update, @spender)
    end

    def ability(group, role_type)
      role = Fabricate(role_type.name.to_sym, group: group)
      Ability.new(role.person.reload)
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
    let(:role) { Fabricate(Group::DachverbandGeschaeftsstelle::Geschaeftsleiter.name.to_sym, group: groups(:dachverband_gs)) }

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

end
