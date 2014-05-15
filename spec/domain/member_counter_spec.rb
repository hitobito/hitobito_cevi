# encoding: utf-8

#  Copyright (c) 2012-2014, Pfadibewegung Schweiz. This file is part of
#  hitobito_pbs and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_pbs.

require 'spec_helper'

describe 'MemberCounter' do
  let(:jungschar_zh10) { groups(:jungschar_zh10) }

  def load_data
    jungschar_zh10_stufe1 = groups(:jungschar_zh10_aranda)
    jungschar_zh10_stufe2 = groups(:jungschar_zh10_salomo)
    jungschar_zh10_froeschli = groups(:jungschar_zh10_froeschli)
    jungschar_zh10_externe = groups(:jungschar_zh10_raeumlichkeit)

    # roles that must be counted
    leader = Fabricate(Group::Jungschar::Abteilungsleiter.name, group: jungschar_zh10,
                       person: Fabricate(:person, gender: 'w', birthday: '1985-01-01'))

    Fabricate(Group::Stufe::Stufenleiter.name, group: jungschar_zh10_stufe1,
              person: Fabricate(:person, gender: 'm', birthday: '1988-01-01'))
    Fabricate(Group::Stufe::Teilnehmer.name, group: jungschar_zh10_stufe1,
              person: Fabricate(:person, gender: 'w', birthday: '1999-02-02'))
    Fabricate(Group::Stufe::Teilnehmer.name, group: jungschar_zh10_stufe2,
              person: Fabricate(:person, gender: 'w', birthday: '2002-02-02'))
    Fabricate(Group::Froeschli::Teilnehmer.name, group: jungschar_zh10_froeschli,
              person: Fabricate(:person, gender: 'w', birthday: '2002-02-02'))

    # roles that must not be counted
    Fabricate(Group::JungscharExterne::Externer.name, group: jungschar_zh10_externe,
              person: Fabricate(:person, gender: 'm', birthday: '1971-01-01'))
    Fabricate(Group::JungscharExterne::Goetti.name, group: jungschar_zh10_externe,
              person: Fabricate(:person, gender: 'w', birthday: '1972-01-01'))
    Fabricate(Group::Jungschar::FreierMitarbeiter.name, group: jungschar_zh10,
              person: Fabricate(:person, gender: 'w', birthday: '1972-01-01'))

    # soft delete role must not be counted
    Fabricate(Group::Jungschar::Abteilungsleiter.name, group: jungschar_zh10,
              person: Fabricate(:person, gender: 'w', birthday: '1977-03-01'),
              created_at: 2.years.ago).destroy
  end

  it 'does not include soft deleted role in group count' do
    load_data

    jungschar_zh10.people.count.should eq 2
    Person.joins('INNER JOIN roles ON roles.person_id = people.id').
           where(roles: { group_id: jungschar_zh10.id }).
           count.should == 3 
  end

  context 'instance' do
    subject { MemberCounter.new(2011, jungschar_zh10) }

    it { should_not be_exists }
    its(:mitgliederorganisation) { should == groups(:zhshgl) }

    context 'with loaded data' do
      before { load_data } 

      its(:members) { should have(5).items }

      it 'creates member counts' do
        expect { subject.count! }.to change { MemberCount.count }.by(1)
        should be_exists
        assert_member_counts(person_f: 4, person_m: 1)
      end
    end
  end

  context '.filtered_roles' do
    subject { MemberCounter.filtered_roles }

    it 'should include desired roles of desired groups' do
      should include(Group::Stufe::Teilnehmer,
                     Group::Jungschar::Abteilungsleiter)
    end

    it 'should exclude ignored roles of desired groups' do
      should_not include(Group::Sport::FreierMitarbeiter,
                         Group::JungscharExterne::Externer)
    end

    it 'should exclude roles from ignored groups' do
      should_not include(Group::DachverbandVorstand::Mitglied)
    end
  end

  context '.create_count_for' do
    it 'creates count with current census' do
      censuses(:two_o_12).destroy
      expect { MemberCounter.create_counts_for(jungschar_zh10) }.to change { MemberCount.where(year: 2011).count }.by(1)
    end

    it 'does not create counts with existing ones' do
      expect { MemberCounter.create_counts_for(jungschar_zh10) }.not_to change { MemberCount.count }
    end

    it 'does not create counts without census' do
      Census.destroy_all
      expect { MemberCounter.create_counts_for(jungschar_zh10) }.not_to change { MemberCount.count }
    end
  end

  context '.current_counts?' do
    before { load_data } 
    subject { MemberCounter.current_counts?(jungschar_zh10) }

    context 'with counts' do
      it { should be_true }
    end

    context 'without counts' do
      before { MemberCount.update_all(year: 2011) }
      it { should be_false }
    end

    context 'with census' do
      before { Census.destroy_all }
      it { should be_false }
    end
  end

  def assert_member_counts(fields = {})
    count = MemberCount.where(group: jungschar_zh10, year: 2011).first
    MemberCount::COUNT_COLUMNS.each do |c|
      expected = fields[c.to_sym] || 0
      count.send(c).to_i.should be(expected), "#{c} should be #{expected}, was #{count.send(c).to_i}"
    end
  end

end
