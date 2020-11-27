# frozen_string_literal: true

#  Copyright (c) 2012-2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe 'MemberCounter' do
  let(:jungschar_zh10) { groups(:jungschar_zh10) }

  def load_data
    Person.destroy_all
    Role.destroy_all

    jungschar_zh10_aranda = groups(:jungschar_zh10_aranda)
    jungschar_zh10_salomo = groups(:jungschar_zh10_salomo)
    jungschar_zh10_froeschli = groups(:jungschar_zh10_froeschli)
    jungschar_zh10_raeumlichkeit = groups(:jungschar_zh10_raeumlichkeit)

    # roles that must be counted
    Fabricate(Group::Jungschar::Abteilungsleiter.name, group: jungschar_zh10,
              person: Fabricate(:person, gender: 'w', birthday: '1985-01-01'))

    Fabricate(Group::Stufe::Stufenleiter.name, group: jungschar_zh10_aranda,
              person: Fabricate(:person, gender: 'm', birthday: '1988-01-01'))
    Fabricate(Group::Stufe::Teilnehmer.name, group: jungschar_zh10_aranda,
              person: Fabricate(:person, gender: 'w', birthday: '1999-02-02'))
    Fabricate(Group::Stufe::Teilnehmer.name, group: jungschar_zh10_salomo,
              person: Fabricate(:person, gender: 'w', birthday: '2002-02-02'))
    Fabricate(Group::Froeschli::Teilnehmer.name, group: jungschar_zh10_froeschli,
              person: Fabricate(:person, gender: 'w', birthday: '2002-02-02'))

    # roles that must not be counted
    Fabricate(Group::JungscharExterne::Externer.name, group: jungschar_zh10_raeumlichkeit,
              person: Fabricate(:person, gender: 'm', birthday: '1971-01-01'))
    Fabricate(Group::JungscharExterne::Goetti.name, group: jungschar_zh10_raeumlichkeit,
              person: Fabricate(:person, gender: 'w', birthday: '1972-01-01'))
    Fabricate(Group::Jungschar::FreierMitarbeiter.name, group: jungschar_zh10,
              person: Fabricate(:person, gender: 'w', birthday: '1972-01-01'))
    Fabricate(Group::Jungschar::Coach.name, group: jungschar_zh10,
              person: Fabricate(:person, gender: 'w', birthday: '1972-01-01'))

    # soft delete role must not be counted
    Fabricate(Group::Jungschar::Abteilungsleiter.name, group: jungschar_zh10,
              person: Fabricate(:person, gender: 'w', birthday: '1977-03-01'),
              created_at: 2.years.ago).destroy
  end

  it 'does not include soft deleted role in group count' do
    load_data

    expect(jungschar_zh10.people.count).to eq 3
    expect(Person.joins('INNER JOIN roles ON roles.person_id = people.id').
           where(roles: { group_id: jungschar_zh10.id }).
           count).to eq(4)
  end

  context 'instance' do
    subject { MemberCounter.new(2011, jungschar_zh10) }

    it { is_expected.not_to be_exists }
    its(:mitgliederorganisation) { should == groups(:zhshgl) }

    context 'with loaded data' do
      before { load_data }

      its(:members) { should have(5).items }

      it 'creates member counts per age group' do
        expect { subject.count! }.to change { MemberCount.count }.by(4)
        is_expected.to be_exists

        assert_member_count(1985, person_f: 1, person_m: nil)
        assert_member_count(1988, person_f: nil, person_m: 1)
        assert_member_count(1999, person_f: 1, person_m: nil)
        assert_member_count(2002, person_f: 2, person_m: nil)
      end
    end
  end

  context '.filtered_roles' do
    subject { MemberCounter.filtered_roles }

    it 'should include desired roles of desired groups' do
      is_expected.to include(Group::Stufe::Teilnehmer,
                             Group::Jungschar::Abteilungsleiter)
    end

    it 'should exclude ignored roles of desired groups' do
      is_expected.not_to include(Group::Sport::FreierMitarbeiter,
                                 Group::JungscharExterne::Externer,
                                 Group::Jungschar::Coach)
    end

    it 'should exclude roles from ignored groups' do
      is_expected.not_to include(Group::DachverbandVorstand::Mitglied)
    end
  end

  context '.create_count_for' do
    before { load_data }

    it 'creates count with current census if no count exists' do
      member_counts(:jungschar_zh10_2012_1999).destroy!
      member_counts(:jungschar_zh10_2012_1997).destroy!
      member_counts(:jungschar_zh10_2012_1988).destroy!
      expect { MemberCounter.create_counts_for(jungschar_zh10) }.to change { MemberCount.count }.by(4)
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
      it { is_expected.to be_truthy }
    end

    context 'without counts' do
      before { MemberCount.update_all(year: 2011) }
      it { is_expected.to be_falsey }
    end

    context 'with census' do
      before { Census.destroy_all }
      it { is_expected.to be_falsey }
    end
  end

  def assert_member_count(born_in, fields = {})
    counts = MemberCount.where(group: jungschar_zh10, year: 2011, born_in: born_in)
    expect(counts).to have(1).item
    count = counts.first

    %w(person_f person_m).each do |c|
      expected = fields[c.to_sym] || 0
      expect(count.send(c).to_i).to be(expected), "#{c} should be #{expected}, was #{count.send(c).to_i}"
    end
  end

end
