# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe MemberCount do
  let(:dachverband) { groups(:dachverband) }
  let(:zhshgl) { groups(:zhshgl) }
  let(:be) { groups(:be) }
  let(:jungschar_zh10) { groups(:jungschar_zh10) }
  let(:jungschar_altst) { groups(:jungschar_altst) }
  let(:jungschar_burgd) { groups(:jungschar_burgd) }

  it 'allows membercounts without born_in' do
    expect(MemberCount.new(person_m: 1, person_f: 1, year: TESTYEAR,
                    group: jungschar_zh10, mitgliederorganisation: zhshgl)).to be_valid
  end

  describe '.total_by_groups' do

    subject { MemberCount.total_by_groups(TESTYEAR, zhshgl).to_a }

    it 'counts totals' do
      is_expected.to have(2).items

      zh10_count = subject.detect { |c| c.group_id == jungschar_zh10.id }
      assert_member_counts(zh10_count, 8, 9)

      altst_count = subject.detect { |c| c.group_id == jungschar_altst.id }
      assert_member_counts(altst_count, 5, 3)
    end
  end

  describe '.total_for_group' do
    subject { MemberCount.total_for_group(TESTYEAR, jungschar_zh10) }

    it 'counts totals' do
      assert_member_counts(subject, 8, 9)
    end
  end

  describe '.total_for_dachverband' do
    subject { MemberCount.total_for_dachverband(TESTYEAR) }

    it 'counts totals' do
      assert_member_counts(subject, 20, 17)
    end
  end

  describe '.total_by_mitgliederorganisationen' do

    subject { MemberCount.total_by_mitgliederorganisationen(TESTYEAR).to_a }

    it 'counts totals' do
      is_expected.to have(2).items

      be_count = subject.detect { |c| c.mitgliederorganisation_id == zhshgl.id }
      assert_member_counts(be_count, 13, 12)

      no_count = subject.detect { |c| c.mitgliederorganisation_id == be.id }
      assert_member_counts(no_count, 7, 5)
    end
  end

  describe '.details_for_group' do
    subject { MemberCount.details_for_group(TESTYEAR, jungschar_zh10).to_a }

    it 'lists all years' do
      expect(subject.collect(&:born_in)).to eq [1988, 1997, 1999]

      assert_member_counts(subject[0], 2, 5) # 1988
      assert_member_counts(subject[1], 4, 1) # 1997
      assert_member_counts(subject[2], 2, 3) # 1999

    end
  end

  describe '.details_for_mitgliederorganisation' do
    subject { MemberCount.details_for_mitgliederorganisation(TESTYEAR, zhshgl).to_a }

    it 'lists all years' do
      expect(subject.collect(&:born_in)).to eq([1988, 1997, 1998, 1999])

      assert_member_counts(subject[0], 2, 5) # 1988
      assert_member_counts(subject[1], 7, 3) # 1997
      assert_member_counts(subject[2], 2, 1) # 1998
      assert_member_counts(subject[3], 2, 3) # 1999
    end
  end

  describe '.details_for_dachverband' do
    subject { MemberCount.details_for_dachverband(TESTYEAR).to_a }

    it 'lists all years' do
      expect(subject.collect(&:born_in)).to eq([1988, 1997, 1998, 1999, 2000])

      assert_member_counts(subject[0], 2, 5) # 1988
      assert_member_counts(subject[1], 7, 3) # 1997
      assert_member_counts(subject[2], 8, 4) # 1998
      assert_member_counts(subject[3], 2, 3) # 1999
      assert_member_counts(subject[4], 1, 2) # 2000
    end
  end

  def assert_member_counts(count, person_f, person_m)
    expect(count.person_f).to eq person_f
    expect(count.person_m).to eq person_m
  end

end
