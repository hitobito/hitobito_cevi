# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe CensusEvaluation::DachverbandController do

  let(:ch)      { groups(:dachverband) }
  let(:be)      { groups(:be) }
  let(:alpin)   { groups(:alpin) }
  let(:zhshgl)  { groups(:zhshgl) }
  let(:zh)      { Fabricate(Group::Mitgliederorganisation.name, name: 'Zurich', parent: ch) }

  before do
    zh # create

    sign_in(people(:bulei))
  end


  describe 'GET index' do

    context 'defaults' do
      before do
        allow(Date).to receive_messages(today: censuses(:two_o_12).finish_at)
        get :index, params: { id: ch.id }
      end


      it 'assigns counts' do
        counts = assigns(:group_counts)
        expect(counts.keys).to match_array([zhshgl.id, be.id])
        expect(counts[zhshgl.id].total).to eq(25)
        expect(counts[be.id].total).to eq(12)
      end

      it 'assigns total' do
        expect(assigns(:total)).to be_kind_of(MemberCount)
      end

      it 'assigns sub groups' do
        expect(assigns(:sub_groups)).to eq [alpin, be, zhshgl, zh]
      end

      it 'assigns groups' do
        expect(assigns(:groups)).to eq({
          alpin.id => { confirmed: 0, total: 0 },
          be.id => { confirmed: 1, total: 1 },
          zhshgl.id => { confirmed: 2, total: 6 },
          zh.id => { confirmed: 0, total: 0 },
        })
      end

      it 'assigns details' do
        details = assigns(:details).to_a
        expect(details).to have(5).items

        expect(details[0].born_in).to eq(1988)
        expect(details[1].born_in).to eq(1997)
        expect(details[2].born_in).to eq(1998)
        expect(details[3].born_in).to eq(1999)
        expect(details[4].born_in).to eq(2000)
      end

      it 'assigns year' do
        expect(assigns(:year)).to eq(Census.last.year)
      end
    end

    context 'totals' do

      it 'is empty member count when viewing current census but no data exists' do
        MemberCount.where(year: 2012).delete_all
        get :index, params: { id: ch.id, year: 2012 }

        expect(assigns(:total).attributes).to eq MemberCount.new.attributes
      end

      it 'is nil when viewing census which has not been created yet' do
        get :index, params: { id: ch.id, year: 2014 }

        expect(assigns(:total)).to be_nil
      end
    end

    context 'csv export' do
      it 'exports data to csv' do
        get :index, params: { id: ch.id }, format: :csv
        expect(CSV.parse(response.body, headers: true)).to have(3).rows
      end
    end
  end

end
