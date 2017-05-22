# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe PersonLayerWritables do

  let(:user) { role.person.reload }
  let(:ability) { PersonLayerWritables.new(user) }
  let(:accessibles) { Person.accessible_by(ability) }

  subject { accessibles }

  context :layer_and_below_full do
    let(:role) { Fabricate(Group::Dachverband::Administrator.name, group: groups(:dachverband)) }

    context 'own layer' do
      it 'may get people' do
        other = Fabricate(Group::DachverbandVorstand::Mitglied.name, group: groups(:dachverband_vorstand))
        is_expected.to include(other.person)
      end
    end

    context 'lower layer' do
      it 'may get people' do
        other = Fabricate(Group::Jungschar::Jugendarbeiter.name, group: groups(:jungschar_zh10))
        is_expected.to include(other.person)
      end

      it 'may not get non-visible people' do
        other = Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_zh10_aranda))
        is_expected.not_to include(other.person)
      end
    end

    context 'in jungschar' do
      let(:role) { Fabricate(Group::Jungschar::Abteilungsleiter.name, group: groups(:jungschar_zh10)) }

      it 'may get people' do
        other = Fabricate(Group::Jungschar::Jugendarbeiter.name, group: groups(:jungschar_zh10))
        is_expected.to include(other.person)
      end

      it 'may get non-visible people' do
        other = Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_zh10_aranda))
        is_expected.to include(other.person)
      end
    end
  end

  context :unconfined_below do
    let(:role) { Fabricate(Group::Ortsgruppe::AdministratorCeviDB.name, group: groups(:stadtzh)) }

    context 'lower layer' do
      it 'may get people' do
        other = Fabricate(Group::Jungschar::Jugendarbeiter.name, group: groups(:jungschar_zh10))
        is_expected.to include(other.person)
      end

      it 'may get non-visible people' do
        other = Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_zh10_aranda))
        is_expected.to include(other.person)
      end
    end
  end

end