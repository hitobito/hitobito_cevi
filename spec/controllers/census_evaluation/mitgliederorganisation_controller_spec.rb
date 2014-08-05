# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe CensusEvaluation::MitgliederorganisationController do

  let(:ch)      { groups(:dachverband) }
  let(:zhshgl)  { groups(:zhshgl) }
  let(:jungschar_zh10) { groups(:jungschar_zh10) }
  let(:jungschar_altst) { groups(:jungschar_altst) }

  before { sign_in(people(:bulei)) }

  describe 'GET index' do
    before { get :index, id: zhshgl.id }

    it 'assigns counts' do
      counts = assigns(:group_counts)
      counts.keys.should =~ [jungschar_zh10.id, jungschar_altst.id]
      counts[jungschar_zh10.id].total.should == 17
      counts[jungschar_altst.id].total.should == 8
    end

    it 'assigns total' do
      assigns(:total).should be_kind_of(MemberCount)
    end

    it 'assigns sub groups' do
      assigns(:sub_groups).should == [jungschar_altst,
                                      groups(:kino),
                                      groups(:lernhilfe),
                                      groups(:sport),
                                      groups(:tensing),
                                      jungschar_zh10]
    end

    it 'assigns details' do
      details = assigns(:details).to_a
      details.should have(4).items

      details[0].born_in.should == 1988
      details[1].born_in.should == 1997
      details[2].born_in.should == 1998
      details[3].born_in.should == 1999
    end
  end

  context 'csv export' do
    it 'exports data to csv' do
      get :index, id: zhshgl.id, format: :csv
      CSV.parse(response.body, headers: true).should have(2).rows
    end
  end

end
