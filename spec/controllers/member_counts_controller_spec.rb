require 'spec_helper'

describe MemberCountsController do

  describe "PATCH#update" do
    let(:count) { member_counts(:jungschar_zh10_2012) }
    let(:group) { count.group }

    it "adds additional attributes" do
      expect { put :update, group_id: group.id, id: count.id,
                additional_member_counts: [ { born_in: 2001,
                                              person_f: 1,
                                              person_m: "" } ] }.to change { group.member_counts }.by(1)
    end
  end
end
