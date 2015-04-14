# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe MemberCountsController, type: :controller do

  render_views

  let(:group) { groups(:zhshgl) }

  before { sign_in(people(:bulei)) }

  describe 'GET edit' do
    before { get :edit, group_id: group.id, year: 2012 }

    it 'should render template' do
      is_expected.to render_template('edit')
    end
  end

end
