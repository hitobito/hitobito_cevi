# encoding: utf-8

#  Copyright (c) 2012-2017, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe Event::ParticipationAbility do

  def build(attrs)
    course = Event::Course.new(groups: attrs.fetch(:groups).map { |g| groups(g) }, tentative_applications: true)
    @participation = Event::Participation.new(event: course, person: attrs[:person])
  end

  let(:participation) { @participation }
  let(:user) { role.person }

  subject { Ability.new(user) }

  context 'participation with person' do

    context 'layer_and_below_full' do
      let(:role) { Fabricate(Group::MitgliederorganisationGeschaeftsstelle::Geschaeftsleiter.name, group: groups(:zhshgl_gs)) }

      it 'may not create_tentative for person in upper layer' do
        person = Fabricate(Group::DachverbandGeschaeftsstelle::Geschaeftsleiter.name, group: groups(:dachverband_gs)).person
        is_expected.not_to be_able_to(:create_tentative, build(groups: [:zhshgl], person: person))
      end

      it 'may create_tentative for person in his layer' do
        person = Fabricate(Group::MitgliederorganisationGremium::Mitglied.name, group: groups(:zhshgl_beirat)).person
        is_expected.to be_able_to(:create_tentative, build(groups: [:zhshgl], person: person))
      end

      it 'may not create_tentative for person in different layer' do
        person = Fabricate(Group::Mitgliederorganisation::Administrator.name, group: groups(:be)).person
        is_expected.not_to be_able_to(:create_tentative, build(groups: [:zhshgl], person: person))
      end

      it 'may create_tentative for person in layer below' do
        person = Fabricate(Group::Jungschar::Jugendarbeiter.name, group: groups(:jungschar_zh10)).person
        is_expected.to be_able_to(:create_tentative, build(groups: [:zhshgl], person: person))
      end

      it 'may not create_tentative for non visible person in layer below' do
        person = Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_zh10_aranda)).person
        is_expected.not_to be_able_to(:create_tentative, build(groups: [:zhshgl], person: person))
      end
    end

    context 'uncofined below' do
      let(:role) { Fabricate(Group::Ortsgruppe::AdministratorCeviDB.name, group: groups(:stadtzh)) }

      it 'may not create_tentative for person in upper layer' do
        person = Fabricate(Group::DachverbandGeschaeftsstelle::Geschaeftsleiter.name, group: groups(:dachverband_gs)).person
        is_expected.not_to be_able_to(:create_tentative, build(groups: [:zhshgl], person: person))
      end

      it 'may create_tentative for person in layer below' do
        person = Fabricate(Group::Jungschar::Jugendarbeiter.name, group: groups(:jungschar_zh10)).person
        is_expected.to be_able_to(:create_tentative, build(groups: [:zhshgl], person: person))
      end

      it 'may create_tentative for non visible person in layer below' do
        person = Fabricate(Group::Stufe::Teilnehmer.name, group: groups(:jungschar_zh10_aranda)).person
        is_expected.to be_able_to(:create_tentative, build(groups: [:zhshgl], person: person))
      end
    end
  end

  context 'Ausbildungsmitglied' do
    let(:role) { Fabricate(Group::MitgliederorganisationGremium::Ausbildungsmitglied.name.to_sym, group: groups(:zhshgl_beirat)) }

    it 'may show participant in same layer course' do
      participation = Fabricate(:event_participation, event: events(:top_course))
      is_expected.to be_able_to(:show, participation)
    end

    it 'may not show participant in same layer event' do
      participation = Fabricate(:event_participation, event: Fabricate(:event, groups: [groups(:zhshgl_beirat)]))
      is_expected.not_to be_able_to(:show, participation)
    end

    it 'may not show participant in lower layer event' do
      participation = Fabricate(:event_participation, event: Fabricate(:event, groups: [groups(:stadtzh)]))
      is_expected.not_to be_able_to(:show, participation)
    end

    it 'may not index participants in other layer course' do
      gremium = Fabricate(Group::MitgliederorganisationGremium.name.to_sym, parent: groups(:be))
      Fabricate(Group::MitgliederorganisationGremium::Mitglied.name.to_sym, group: gremium)
      participation = Fabricate(:event_participation, event: Fabricate(:event, groups: [groups(:be)]))
      is_expected.not_to be_able_to(:show, participation)
    end
  end
end
