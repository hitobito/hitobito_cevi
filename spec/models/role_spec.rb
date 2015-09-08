# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  group_id   :integer          not null
#  type       :string(255)      not null
#  label      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  deleted_at :datetime
#



require 'spec_helper'

describe Role do

  describe Group::DachverbandExterne::Externer do
    subject {  Group::DachverbandExterne::Externer }
    it { is_expected.not_to be_visible_from_above }
  end

  describe Group::JungscharExterne::Externer do
    subject {  Group::JungscharExterne::Externer }
    it { is_expected.not_to be_visible_from_above }
  end

  describe Group::MitgliederorganisationExterne::Externer do
    subject {  Group::MitgliederorganisationExterne::Externer }
    it { is_expected.not_to be_visible_from_above }
  end

  describe Group::SportExterne::Externer do
    subject {  Group::SportExterne::Externer }
    it { is_expected.not_to be_visible_from_above }
  end

  describe Group::TenSingExterne::Externer do
    subject {  Group::TenSingExterne::Externer }
    it { is_expected.not_to be_visible_from_above }
  end

  describe Group::VereinExterne::Externer do
    subject {  Group::VereinExterne::Externer }
    it { is_expected.not_to be_visible_from_above }
  end

  describe Group::WeitereArbeitsgebieteExterne::Externer do
    subject {  Group::WeitereArbeitsgebieteExterne::Externer }
    it { is_expected.not_to be_visible_from_above }
  end

  context '#reset_person_ortsgruppe!' do
    let(:person) { Fabricate(:person) }

    it 'updates the person\'s ortsgruppe if available' do
      Fabricate(Group::Jungschar::Abteilungsleiter.name.to_sym,
                group: groups(:jungschar_zh10), person: person)
      expect(person.ortsgruppe_id).to eq(groups(:stadtzh).id)
    end

    it 'leaves person\'s ortsgruppe nil if no ortsgruppe is in hierarchy' do
      Fabricate(Group::Dachverband::Administrator.name.to_sym,
                group: groups(:dachverband), person: person)
      expect(person.ortsgruppe_id).to be_nil
    end

    it 'does not touch person\'s ortsgruppe if it already has groups' do
      Fabricate(Group::Dachverband::Administrator.name.to_sym,
                group: groups(:dachverband), person: person)
      Fabricate(Group::Jungschar::Abteilungsleiter.name.to_sym,
                group: groups(:jungschar_zh10), person: person.reload)
      expect(person.ortsgruppe_id).to be_nil
    end

    it 'updates ortsgruppe in same transaction' do
      person = Person.new(first_name: 'John')
      person.roles.new(group: groups(:jungschar_zh10),
                       type: Group::Jungschar::Abteilungsleiter.sti_name)
      person.save!
      expect(person.reload.ortsgruppe_id).to eq(groups(:stadtzh).id)
    end
  end
end
