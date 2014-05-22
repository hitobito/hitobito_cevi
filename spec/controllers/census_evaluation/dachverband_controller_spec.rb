# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito_jubla and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_jubla.

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
        Date.stub(today: censuses(:two_o_12).finish_at)
        get :index, id: ch.id
      end


      it 'assigns counts' do
        counts = assigns(:group_counts)
        counts.keys.should =~ [zhshgl.id, be.id]
        counts[zhshgl.id].total.should == 25
        counts[be.id].total.should == 12
      end

      it 'assigns total' do
        assigns(:total).should be_kind_of(MemberCount)
      end

      it 'assigns sub groups' do
        assigns(:sub_groups).should eq [alpin, be, zhshgl, zh]
      end

      it 'assigns groups' do
        assigns(:groups).should == {
          alpin.id => { confirmed: 0, total: 0 },
          be.id => { confirmed: 1, total: 1 },
          zhshgl.id => { confirmed: 2, total: 6 },
          zh.id => { confirmed: 0, total: 0 },
        }
      end

      it 'assigns details' do
        details = assigns(:details).to_a
        details.should have(5).items

        details[0].born_in.should == 1988
        details[1].born_in.should == 1997
        details[2].born_in.should == 1998
        details[3].born_in.should == 1999
        details[4].born_in.should == 2000
      end

      it 'assigns year' do
        assigns(:year).should == Census.last.year
      end
    end

    context 'totals' do

      it 'is empty member count when viewing current census but no data exists' do
        MemberCount.where(year: 2012).delete_all
        get :index, id: ch.id, year: 2012

        assigns(:total).attributes.should eq MemberCount.new.attributes
      end

      it 'is nil when viewing census which has not been created yet' do
        get :index, id: ch.id, year: 2014

        assigns(:total).should be_nil
      end
    end
  end

end
