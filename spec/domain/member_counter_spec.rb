# encoding: utf-8

#  Copyright (c) 2012-2014, Pfadibewegung Schweiz. This file is part of
#  hitobito_pbs and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_pbs.

require 'spec_helper'

describe 'MemberCounter' do

  let(:jungschar1) { groups(:jungschar_zh10) }
  let(:jungschar2) { groups(:jungschar_altst) }

  before do
    jungschar1_stufe1 = groups(:jungschar_zh10_aranda)
    jungschar1_stufe2 = groups(:jungschar_zh10_salomo)
    jungschar1_froeschli = groups(:jungschar_zh10_froeschli)
    jungschar1_externe = groups(:jungschar_zh10_raeumlichkeit)

    jungschar2_stufe1 = groups(:jungschar_altst_0405)
    jungschar2_stufe1_gruppe1 = groups(:jungschar_altst_0405_ammon)
    jungschar2_stufe1_gruppe2 = groups(:jungschar_altst_0405_genesis)
    jungschar2_stufe2 = groups(:jungschar_altst_0203)
    jungschar2_stufe2_gruppe1 = groups(:jungschar_altst_0203_masada)

    leader = Fabricate(Group::Jungschar::Abteilungsleiter.name, group: jungschar1,
                       person: Fabricate(:person, gender: 'w', birthday: '1985-01-01'))

    Fabricate(Group::Stufe::Stufenleiter.name, group: jungschar1_stufe1,
              person: Fabricate(:person, gender: 'm', birthday: '1988-01-01'))
    Fabricate(Group::Stufe::Teilnehmer.name, group: jungschar1_stufe1,
              person: Fabricate(:person, gender: 'w', birthday: '1999-02-02'))
    Fabricate(Group::Stufe::Teilnehmer.name, group: jungschar1_stufe2,
              person: Fabricate(:person, gender: 'w', birthday: '2002-02-02'))
    Fabricate(Group::Froeschli::Teilnehmer.name, group: jungschar1_froeschli,
              person: Fabricate(:person, gender: 'w', birthday: '2002-02-02'))

    Fabricate(Group::Stufe::Stufenleiter.name, group: jungschar2_stufe1,
              person: Fabricate(:person, gender: 'm', birthday: '1988-01-01'))
    Fabricate(Group::Stufe::Teilnehmer.name, group: jungschar2_stufe1_gruppe1,
              person: Fabricate(:person, gender: 'm', birthday: '1988-01-01'))
    Fabricate(Group::Stufe::Teilnehmer.name, group: jungschar2_stufe1_gruppe2,
              person: Fabricate(:person, gender: 'm', birthday: '1988-01-01'))
    Fabricate(Group::Stufe::Teilnehmer.name, group: jungschar2_stufe2_gruppe1,
              person: Fabricate(:person, gender: 'm', birthday: '1988-01-01'))

    # roles that must not be counted
    Fabricate(Group::JungscharExterne::Externer.name, group: jungschar1_externe,
              person: Fabricate(:person, gender: 'm', birthday: '1971-01-01'))
    Fabricate(Group::JungscharExterne::Goetti.name, group: jungschar1_externe,
              person: Fabricate(:person, gender: 'w', birthday: '1972-01-01'))
    Fabricate(Group::Jungschar::FreierMitarbeiter.name, group: jungschar1,
              person: Fabricate(:person, gender: 'w', birthday: '1972-01-01'))

    old = Fabricate(Group::Stufe::Stufenleiter.name, group: jungschar1_stufe2,
                    person: Fabricate(:person, gender: 'w', birthday: '1977-03-01'),
                    created_at: 2.years.ago)
    old.destroy # soft delete role
  end

  # it 'exists passive and deleted people as well' do
  #   jungschar1.people.count.should eq 4
  #   Person.joins('INNER JOIN roles ON roles.person_id = people.id').
  #          where(roles: { group_id: jungschar1.id }).
  #          count.should == 5
  # end

  # context 'instance' do

  #   subject { MemberCounter.new(2011, jungschar1) }

  #   it { should_not be_exists }

  #   its(:kantonalverband) { should == groups(:be) }

  #   its(:region) { should == groups(:bern) }

  #   its(:members) { should have(9).items }

  #   it 'creates member counts' do
  #     expect { subject.count! }.to change { MemberCount.count }.by(1)

  #     should be_exists

  #     assert_member_counts(leiter_f: 3, leiter_m: 1,
  #                          pfadis_f: 3, pfadis_m: 1,
  #                          woelfe_f: 1)
  #   end

  # end

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
      expect { MemberCounter.create_counts_for(jungschar1) }.to change { MemberCount.where(year: 2011).count }.by(1)
    end

    it 'does not create counts with existing ones' do
      expect { MemberCounter.create_counts_for(jungschar1) }.not_to change { MemberCount.count }
    end

    it 'does not create counts without census' do
      Census.destroy_all
      expect { MemberCounter.create_counts_for(jungschar1) }.not_to change { MemberCount.count }
    end
  end

  # context '.current_counts?' do
  #   subject { MemberCounter.current_counts?(abteilung) }

  #   context 'with counts' do
  #     it { should be_true }
  #   end

  #   context 'without counts' do
  #     before { MemberCount.update_all(year: 2011) }
  #     it { should be_false }
  #   end

  #   context 'with census' do
  #     before { Census.destroy_all }
  #     it { should be_false }
  #   end
  # end

  # def assert_member_counts(fields = {})
  #   count = MemberCount.where(abteilung_id: abteilung.id, year: 2011).first
  #   MemberCount::COUNT_COLUMNS.each do |c|
  #     expected = fields[c.to_sym] || 0
  #     count.send(c).to_i.should be(expected), "#{c} should be #{expected}, was #{count.send(c).to_i}"
  #   end
  # end

end
