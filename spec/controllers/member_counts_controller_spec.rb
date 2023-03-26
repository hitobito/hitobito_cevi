# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe MemberCountsController do
  let(:group) { groups(:jungschar_zh10) }

  before { sign_in(people(:bulei)) }

  describe 'GET edit' do
    context 'in ' + TESTYEAR.to_s do
      before { get :edit, params: { group_id: group.id } }

      it 'assigns counts' do
       expect(assigns(:member_counts)).to have(3).items
       expect(assigns(:group)).to eq group
      end
    end
  end

  describe 'PUT update' do
    context 'as administrator dachverband' do

      it 'updates counts' do
        put :update, params: { group_id: group.id, year: TESTYEAR, member_count:
          { member_counts(:jungschar_zh10_jg_1999).id => { person_f: 4, person_m: '1'},
            member_counts(:jungschar_zh10_jg_1997).id => { person_f: 2, person_m: ''},
            member_counts(:jungschar_zh10_jg_1988).id => { person_f: nil, person_m: 0},
          } }

        assert_member_counts(member_counts(:jungschar_zh10_jg_1999).reload, 4, 1)
        assert_member_counts(member_counts(:jungschar_zh10_jg_1997).reload, 2, nil)
        assert_member_counts(member_counts(:jungschar_zh10_jg_1988).reload, nil, 0)

        is_expected.to redirect_to(census_group_group_path(group, year: TESTYEAR))
      end

      it "saves additional member counts" do
        expect do
           put :update,
               params: {
                 group_id: group.id,
                 additional_member_counts: [ { born_in: 2001,
                                               person_f: 1,
                                               person_m: "" } ]
               }
        end.to change { group.reload.member_counts.count }.by(1)

        is_expected.to redirect_to(census_group_group_path(group, year: TESTYEAR))
      end

      it "renders flash for invalid additional count" do
        expect do
          put :update,
              params: {
                group_id: group.id,
                additional_member_counts: [ { born_in: 'asdf',
                                              person_f: 1,
                                              person_m: "" } ]
              }
        end.not_to change { group.reload.member_counts.count }
        expect(flash[:alert]).to be_present
      end

      it "renders flash for additional count of existing year" do
        expect do
           put :update,
               params: {
                 group_id: group.id,
                 additional_member_counts: [ { born_in: 1999,
                                               person_f: 1,
                                               person_m: "" } ]
               }
        end.not_to change { group.reload.member_counts.count }
        expect(flash[:alert]).to be_present
      end

    end

    context 'as abteilungsleiter' do
      it 'denies access' do
        leiter = Fabricate(Group::Jungschar::Abteilungsleiter.name.to_sym, group: group).person
        sign_in(leiter)
        expect { put :update, params: {group_id: group.id, year: TESTYEAR, member_count: {}} }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'POST create' do
    it 'handles request with redirect' do
      censuses(:two_o_12).destroy
      post :create, params: { group_id: group.id }

      is_expected.to redirect_to(census_group_group_path(group, year: TESTYEAR-1))
      expect(flash[:notice]).to be_present
    end

    it 'should not change anything if counts exist' do
      expect { post :create, params: { group_id: group.id } }.not_to change { MemberCount.count }
    end

    it 'should create counts' do
      censuses(:two_o_12).destroy
      roles(:al_zh10).destroy
      roles(:zh10_froeschli).destroy
      Fabricate(Group::Jungschar::Abteilungsleiter.name.to_sym,
                group: group,
                person: Fabricate(:person, gender: 'm', birthday: Date.new(1980, 1, 1)))
      Fabricate(Group::Stufe::Stufenleiter.name.to_sym,
                group: groups(:jungschar_zh10_aranda),
                person: Fabricate(:person, gender: 'w', birthday: Date.new(1982, 1, 1)))
      Fabricate(Group::Stufe::Teilnehmer.name.to_sym,
                group: groups(:jungschar_zh10_aranda),
                person: Fabricate(:person, gender: 'm', birthday: Date.new(2000, 12, 31)))

      expect { post :create, params: { group_id: group.id } }.to change { MemberCount.count }.by(3)

      counts = MemberCount.where(group_id: group.id, year: TESTYEAR-1).order(:born_in).to_a
      expect(counts).to have(3).items

      assert_member_counts(counts[0], nil, 1)
      assert_member_counts(counts[1], 1, nil)
      assert_member_counts(counts[2], nil, 1)
    end

    context 'as abteilungsleiter' do
      it 'creates counts' do
        censuses(:two_o_12).destroy
        leader = Fabricate(Group::Jungschar::Abteilungsleiter.name.to_sym, group: group,
                           person: Fabricate(:person, gender: 'm',
                                             birthday: Date.new(2000, 12, 31))).person

        sign_in(leader)
        post :create, params: { group_id: group.id }

        is_expected.to redirect_to(census_group_group_path(group, year: TESTYEAR-1))
        expect(flash[:notice]).to be_present
      end
    end

    context 'as stufenleiter' do
      it 'restricts access' do
        guide = Fabricate(Group::Stufe::Stufenleiter.name.to_sym,
                          group: groups(:jungschar_zh10_aranda)).person
        sign_in(guide)
        expect { post :create, params: { group_id: group.id } }.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'DELETE destroy' do
    it 'removes member count' do
      expect { delete :destroy, params: { group_id: group.id } }.to change { MemberCount.count }.by(-3)
    end

    it 'handles request with redirect' do
      delete :destroy, params: { group_id: group.id }

      is_expected.to redirect_to(census_group_group_path(group, year: TESTYEAR))
      expect(flash[:notice]).to be_present
    end
  end

  def assert_member_counts(count, person_f, person_m)
    expect(count.person_f).to eq person_f
    expect(count.person_m).to eq person_m
  end

end
