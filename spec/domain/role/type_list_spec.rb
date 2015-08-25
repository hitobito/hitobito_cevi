# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Role::TypeList do

  it 'contains all roles for Jungschar' do
    list = Role::TypeList.new(Group::Jungschar)
    expect(list.to_enum.to_a.size).to eq(1)
    expect(list.to_enum.to_a.first.first).to eq('Jungschar')
    expect(list.to_enum.to_a.first.last.keys).to eq(%w(Jungschar Externe Fröschli Stufe Untergruppe Team Spender))
  end

  it 'contains all roles for Stufe' do
    list = Role::TypeList.new(Group::Stufe)
    expect(list.to_enum.to_a.first.first).to eq('Stufe')
    expect(list.to_enum.to_a.first.last.keys).to eq(%w(Stufe Untergruppe))
  end

end
