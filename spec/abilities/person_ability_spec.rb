# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'


describe PersonAbility do

  context :update do
    before do
      @group = Fabricate(Group::Mitgliederorganisation::MitgliederorganisationSpender.name, parent: groups(:zhshgl))
      @spender = Fabricate(Group::MitgliederorganisationSpender::Spender.name, group: @group).person
    end

    context 'upper layer' do
      it 'layer admin may not update spender' do
        ability(groups(:dachverband),
                Group::Dachverband::Administrator).should_not be_able_to(:update, @spender)
      end

      it 'layer finance may not update spender' do
        ability(groups(:dachverband_gs),
                Group::DachverbandGeschaeftsstelle::Finanzverantwortlicher).should_not be_able_to(:update, @spender)
      end
    end


    context 'same layer' do
      it 'layer admin may not update spender' do
        ability(groups(:zhshgl),
                Group::Mitgliederorganisation::Administrator).should_not be_able_to(:update, @spender)
      end

      it 'layer finance may update spender' do
        ability(groups(:zhshgl_gs),
                Group::MitgliederorganisationGeschaeftsstelle::Finanzverantwortlicher).should be_able_to(:update, @spender)
      end
    end

    it 'group full may update spender' do
      ability(@group,
              Group::MitgliederorganisationSpender::SpendenVerwalter).should be_able_to(:update, @spender)
    end


    def ability(group, role_type)
      role = Fabricate(role_type.name.to_sym, group: group)
      Ability.new(role.person.reload)
    end
  end
end
