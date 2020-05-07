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
    before { get :index, params: { id: zhshgl.id } }

    it 'assigns counts' do
      counts = assigns(:group_counts)
      expect(counts.keys).to match_array([jungschar_zh10.id, jungschar_altst.id])
      expect(counts[jungschar_zh10.id].total).to eq(17)
      expect(counts[jungschar_altst.id].total).to eq(8)
    end

    it 'assigns total' do
      expect(assigns(:total)).to be_kind_of(MemberCount)
    end

    it 'assigns sub groups' do
      expect(assigns(:sub_groups)).to eq([jungschar_altst,
                                      groups(:kino),
                                      groups(:lernhilfe),
                                      groups(:sport),
                                      groups(:tensing),
                                      jungschar_zh10])
    end

    it 'assigns details' do
      details = assigns(:details).to_a
      expect(details).to have(4).items

      expect(details[0].born_in).to eq(1988)
      expect(details[1].born_in).to eq(1997)
      expect(details[2].born_in).to eq(1998)
      expect(details[3].born_in).to eq(1999)
    end
  end

  context 'csv export' do
    it 'exports data to csv' do
      get :index, params: { id: zhshgl.id }, format: :csv
      expect(CSV.parse(response.body, headers: true)).to have(2).rows
    end
  end

end
