# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe CensusEvaluation::GroupController do

  let(:zh) { groups(:jungschar_zh10) }

  before { sign_in(people(:bulei)) }

  describe 'GET total' do

    before { get :index, id: zh.id }

    it 'assigns counts' do
      expect(assigns(:group_counts)).to be_nil
    end

    it 'assigns total' do
      total = assigns(:total)
      expect(total).to be_kind_of(MemberCount)
      expect(total.total).to eq(17)
    end

    it 'assigns sub groups' do
      expect(assigns(:sub_groups)).to be_blank
    end

    it 'assigns details' do
      details = assigns(:details).to_a
      expect(details).to have(3).items
      expect(details[0].born_in).to eq(1988)
      expect(details[1].born_in).to eq(1997)
      expect(details[2].born_in).to eq(1999)
    end
  end

end
