# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'


shared_examples 'sub_groups' do
  subject { evaluation.sub_groups.collect(&:name) }

  shared_examples 'sub_groups_examples' do

    context 'for current census' do
      it { should eq current_census_groups.collect(&:name).sort }
    end

    context 'for past census' do
      before do
        # create another census after the current to make this a past one
        Census.create!(year: year + 1,
                       start_at: census.start_at + 1.year)
      end

      it { should eq past_census_groups.collect(&:name).sort }
    end

    context 'for future census' do
      let(:year) { 2100 }
      before do
        Census.create!(year: 2100,
                       start_at: Date.new(2100, 1, 1))
      end

      it { should eq future_census_groups.collect(&:name).sort }
    end
  end

  context 'when noop' do
    let(:current_census_groups) { subgroups }
    let(:past_census_groups)    { subgroups - [group_without_count] }
    let(:future_census_groups)  { subgroups }

    include_examples 'sub_groups_examples'
  end

  context 'when creating new group' do
    let!(:dummy) do
      d = Fabricate(group_to_delete.class.name.to_sym, parent: parent, name: 'Dummy')
      group.reload # because lft, rgt changed
      d
    end
    let(:current_census_groups) { subgroups + [dummy] }
    let(:past_census_groups)    { subgroups - [group_without_count] } # dummy has no count
    let(:future_census_groups)  { subgroups + [dummy] }

    include_examples 'sub_groups_examples'
  end

  context 'when deleting group' do
    context 'deleting group only' do
      let(:current_census_groups) { subgroups }
      let(:past_census_groups)    { subgroups - [group_without_count] } # group included as it has count
      let(:future_census_groups)  { subgroups - [group_to_delete] }

      before { delete_group_and_children }

      include_examples 'sub_groups_examples'
    end

    context 'deleting group and member count' do
      let(:current_census_groups) { subgroups - [group_to_delete] }
      let(:past_census_groups)    { subgroups - [group_to_delete, group_without_count] } # dummy has no count
      let(:future_census_groups)  { subgroups - [group_to_delete] }

      before do
        delete_group_and_children
        delete_group_member_counts
      end

      include_examples 'sub_groups_examples'
    end
  end

  context 'when merging groups' do
    before do
      if group_to_delete.is_a?(Group::Mitgliederorganisation)
        [group_to_delete, group_without_count].each { |g| g.events.destroy_all }
      end

      merger = Group::Merger.new(group_to_delete, group_without_count, 'Dummy')
      merger.merge!.should be_true
      @dummy = merger.new_group
    end

    let(:current_census_groups) { subgroups - [group_without_count] + [@dummy] }
    let(:past_census_groups)    { subgroups - [group_without_count]  } # only groups with count
    let(:future_census_groups)  { subgroups - [group_to_delete, group_without_count] + [@dummy] }

    include_examples 'sub_groups_examples'
  end
end


describe CensusEvaluation do

  let(:dachverband)    { groups(:dachverband) }
  let(:zhshgl)         { groups(:zhshgl) }
  let(:be)             { groups(:be) }
  let(:alpin)          { groups(:alpin) }
  let(:jungschar_zh10) { groups(:jungschar_zh10) }

  let(:census) { censuses(:two_o_12) }
  let(:year)   { census.year }
  let(:evaluation) { CensusEvaluation.new(year, group, sub_group_type) }


  context 'for dachverband' do
    let(:group) { dachverband }
    let(:parent) { dachverband }
    let(:sub_group_type) { Group::Mitgliederorganisation }

    it 'census is current census' do
      evaluation.should be_census_current
    end

    it '#counts_by_sub_group' do
      counts = evaluation.counts_by_sub_group
      counts.keys.should =~ [zhshgl.id, be.id]
      counts[zhshgl.id].total.should eq 25
      counts[be.id].total.should eq 12
    end

    it '#total' do
      evaluation.total.should be_kind_of(MemberCount)
    end

    it '#sub_groups' do
      evaluation.sub_groups.should eq [alpin, be, zhshgl]
    end

    it_behaves_like 'sub_groups' do
      let(:subgroups)           { [zhshgl, be, alpin] }
      let(:group_to_delete)     { be }
      let(:group_without_count) { alpin }
    end
  end

  context 'for mitgliederorganisation' do
    before do
      # NOTE: using group.really_destroy! had weird behaviour
      #  - group itself has hard deleted (removed from table)
      #  - subgroups was soft deleted (delted_at was present)
      %w(tensing lernhilfe kino sport).each do |name|
        group = groups(name.to_sym)
        Group.where(id: group.descendants.pluck(:id)).delete_all
        group.really_destroy!
      end
    end

    let(:group) { zhshgl }
    let(:parent) { groups(:stadtzh) }
    let(:sub_group_type) { MemberCounter::TOP_LEVEL }
    let(:jungschar_altst) { groups(:jungschar_altst) }
    let!(:jungschar_zh11)  { Fabricate(Group::Jungschar.name.to_sym, parent: parent, name: 'Zürich1 11') }

    it '#counts_by_sub_group' do
      counts = evaluation.counts_by_sub_group
      counts.keys.should =~ [jungschar_zh10.id, jungschar_altst.id]
      counts[jungschar_zh10.id].total.should eq 17
      counts[jungschar_altst.id].total.should eq 8
    end

    it '#sub groups' do
      evaluation.sub_groups.should eq [jungschar_altst, jungschar_zh10, jungschar_zh11]
    end

    it_behaves_like 'sub_groups' do
      let(:subgroups)           { [jungschar_zh10, jungschar_zh11, jungschar_altst] }
      let(:group_to_delete)     { jungschar_zh10 }
      let!(:group_without_count) { jungschar_zh11}

      context 'when moving group' do
        let(:target) { zhshgl }
        let(:jungschar_burgd) { groups(:jungschar_burgd) }

        context 'before count' do
          before do
            Group::Mover.new(jungschar_burgd).perform(target).should be_true
            target.reload
          end

          context 'in new parent' do
            before do
              member_counts(:jungschar_burgd_2012_1998).destroy
              member_counts(:jungschar_burgd_2012_2000).destroy
            end

            include_examples 'sub_groups_examples' do
              let(:current_census_groups) { subgroups + [jungschar_burgd] }
              let(:past_census_groups)    { subgroups - [group_without_count] }
              let(:future_census_groups)  { subgroups + [jungschar_burgd] }
            end
          end

          context 'in old parent' do
            let(:group) { groups(:be) }

            context '' do
              before do
                member_counts(:jungschar_burgd_2012_1998).destroy
                member_counts(:jungschar_burgd_2012_2000).destroy
              end

              include_examples 'sub_groups_examples' do
                let(:current_census_groups) { [] }
                let(:past_census_groups)    { [] } # empty for spec implementation reasons, tested in example below
                let(:future_census_groups)  { [] }
              end
            end

            context 'for past census' do
              subject { evaluation.sub_groups.collect(&:name) }

              it 'contains moved group' do
                 Census.create!(year: census.year + 1,
                                start_at: census.start_at + 1.year)
                 should eq [jungschar_burgd].collect(&:name).sort
              end
            end
          end

        end

        context 'after count' do
          before do
            Group::Mover.new(jungschar_burgd).perform(target).should be_true
            target.reload
          end

          context 'in new parent' do
            include_examples 'sub_groups_examples' do
              let(:current_census_groups) { subgroups }
              let(:past_census_groups)    { subgroups - [group_without_count] }
              let(:future_census_groups)  { subgroups + [jungschar_burgd] }
            end
          end

          context 'in old parent' do
            let(:group) { groups(:be) }

            include_examples 'sub_groups_examples' do
              let(:current_census_groups) { [jungschar_burgd] }
              let(:past_census_groups)    { [jungschar_burgd] }
              let(:future_census_groups)  { [] }
            end
          end
        end
      end
    end
  end

  context 'for group' do
    let(:group) { jungschar_zh10 }
    let(:sub_group_type) { nil }

    it '#counts_by_sub_group' do
      evaluation.counts_by_sub_group.should be_blank
    end

    it '#total' do
      total = evaluation.total
      total.should be_kind_of(MemberCount)
      total.total.should eq 17
    end

    it '#sub_groups' do
      evaluation.sub_groups.should be_blank
    end
  end
end


def delete_group_member_counts
  field = "#{group_to_delete.class.model_name.element}_id"
  if MemberCounter::TOP_LEVEL.include?(group_to_delete.class)
    field = 'group_id'
  end
  MemberCount.destroy_all(field => group_to_delete.id)
end

# Group#protect_if :children_without_deleted
# we first delete children, then group and validate return values
def delete_group_and_children(deleted_at = Time.zone.now)
  group_to_delete.update_column(:deleted_at, deleted_at)
  group_to_delete.should be_destroyed
end
