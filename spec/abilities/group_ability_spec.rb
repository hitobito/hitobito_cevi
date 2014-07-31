# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'


describe GroupAbility do

  %w(remind_census update_member_counts delete_member_counts).each do |action|
    it "may #{action} on layer below" do
      ability(groups(:dachverband),
              Group::Dachverband::Administrator).
              should be_able_to(action.to_sym, groups(:jungschar_zh10))
    end

    it "may not #{action} on same layer" do
      ability(groups(:jungschar_zh10),
              Group::Jungschar::Abteilungsleiter).
              should_not be_able_to(action.to_sym, groups(:jungschar_zh10))
    end
  end

  def ability(group, role_type)
    role = Fabricate(role_type.name.to_sym, group: group)
    Ability.new(role.person.reload)
  end

end
