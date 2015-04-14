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
end
