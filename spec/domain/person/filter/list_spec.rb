# encoding: utf-8

#  Copyright (c) 2012-2019, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe Person::Filter::List do
  let(:dachverband) { groups(:dachverband) }
  let(:bulei)       { people(:bulei) }

  before do
    @spenders = Fabricate(Group::DachverbandSpender.sti_name, parent: dachverband)
    @spender  = Fabricate(Group::DachverbandSpender::Spender.sti_name, group: @spenders).person
  end

  def self.each_range
    [nil, 'deep', 'layer'].each do |range|
      yield range
    end
  end


  context Group::Dachverband::Administrator do
    it "deep hides other spender role" do
      filtered = filter(range: 'deep')
      expect(filtered.entries).to be_empty
      expect(filtered.all_count).to eq 1
    end

    it "layer hides other spender role, shows himself" do
      filtered = filter(range: 'layer')
      expect(filtered.entries).to eq([bulei])
      expect(filtered.all_count).to eq 2
    end

    it "hides other spender role" do
      filtered = filter(range: nil)
      expect(filtered.entries).to be_empty
      expect(filtered.all_count).to eq 1
    end
  end

  context Group::DachverbandSpender::Spender do
    before { Fabricate(Group::DachverbandSpender::Spender.sti_name, group: @spenders, person: bulei) }

    each_range do |range|
      it "#{range} hides other spender role, shows own spender role" do
        filtered = filter(range: range)
        expect(filtered.entries).to match_array([bulei])
        expect(filtered.all_count).to eq 2
      end
    end
  end

  context Group::DachverbandSpender::SpendenVerwalter do
    before { Fabricate(Group::DachverbandSpender::SpendenVerwalter.sti_name, group: @spenders, person: bulei) }

    each_range do |range|
      it "#{range} shows other spender role" do
        filtered = filter(range: range)
        expect(filtered.entries).to match_array([@spender, bulei])
        expect(filtered.all_count).to eq 2
      end
    end
  end

  def filter(range: nil, group: @spenders, filter: PeopleFilter.new(name: 'name', range: range))
    Person::Filter::List.new(group, bulei, filter)
  end
end
