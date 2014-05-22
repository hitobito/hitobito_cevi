# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe CensusEvaluation::GroupController, type: :controller do

  render_views

  before { sign_in(people(:bulei)) }

  describe 'GET total' do
    before { get :index, id: groups(:jungschar_zh10).id }

    it 'renders correct templates' do
      should render_template('index')
    end
  end

end
