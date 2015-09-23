# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
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
end
