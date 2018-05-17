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
#  founding_date  :date
#

class Group::Dachverband < Group

  self.layer = true
  self.event_types = [Event, Event::Course]
  self.contact_group_type = Group::DachverbandGeschaeftsstelle


  children Group::DachverbandVorstand,
           Group::DachverbandGeschaeftsstelle,
           Group::DachverbandGremium,
           Group::DachverbandMitglieder,
           Group::DachverbandExterne,
           Group::DachverbandSpender,
           Group::Mitgliederorganisation

  ### ROLES

  class Administrator < ::Role
    self.permissions = [:admin, :layer_and_below_full, :impersonation]
  end

  roles Administrator

  def census_groups(year)
    MemberCount.total_by_mitgliederorganisationen(year)
  end

  def census_total(year)
    MemberCount.total_for_dachverband(year)
  end

  def census_details(year)
    MemberCount.details_for_dachverband(year)
  end

  def member_counts
    MemberCount.all
  end

end
