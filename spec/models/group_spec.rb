# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

# == Schema Information
#
# Table name: groups
#
#  id             :integer          not null, primary key
#  parent_id      :integer
#  lft            :integer
#  rgt            :integer
#  name           :string(255)      not null
#  short_name     :string(31)
#  type           :string(255)      not null
#  email          :string(255)
#  address        :string(1024)
#  zip_code       :integer
#  town           :string(255)
#  country        :string(255)
#  contact_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#  deleted_at     :datetime
#  layer_group_id :integer
#  creator_id     :integer
#  updater_id     :integer
#  deleter_id     :integer
#

require 'spec_helper'

describe Group do
  include_examples 'group types'

  describe '#all_types' do
    subject { Group.all_types }

    it 'is in hierarchical order' do
      expect(subject.collect(&:name)).to eq(
        [Group::Dachverband,
         Group::Mitgliederorganisation,
         Group::Sektion,
         Group::Ortsgruppe,
         Group::Jungschar,
         Group::JungscharExterne,
         Group::Froeschli,
         Group::Stufe,
         Group::Gruppe,
         Group::JungscharTeam,
         Group::Verein,
         Group::VereinVorstand,
         Group::VereinMitglieder,
         Group::VereinExterne,
         Group::TenSing,
         Group::TenSingTeamGruppe,
         Group::TenSingExterne,
         Group::Sport,
         Group::SportTeamGruppe,
         Group::SportExterne,
         Group::WeitereArbeitsgebiete,
         Group::WeitereArbeitsgebieteExterne,
         Group::WeitereArbeitsgebieteTeamGruppe,
         Group::DachverbandVorstand,
         Group::DachverbandGeschaeftsstelle,
         Group::DachverbandGremium,
         Group::DachverbandMitglieder,
         Group::DachverbandExterne
        ].collect(&:name))
    end
  end


end
