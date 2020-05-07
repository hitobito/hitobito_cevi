# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe CensusEvaluation::DachverbandController, type: :controller do

  render_views

  let(:ch)   { groups(:dachverband) }
  let(:zh)   { Fabricate(Group::Mitgliederorganisation.name, name: 'Zurich', parent: ch) }

  before do
    zh # create
    sign_in(people(:bulei))
  end

  describe 'GET total' do
    context 'as admin' do
      before { get :index, params: { id: ch.id } }

      it 'renders correct templates' do
        is_expected.to render_template('index')
        is_expected.to render_template('_totals')
      end
    end
  end

end
