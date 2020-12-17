# frozen_string_literal: true

#  Copyright (c) 2012-2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

Rails.application.routes.draw do

  extend LanguageRouteScope

  language_scope do

    resources :censuses, only: [:new, :create]
    get 'censuses' => 'censuses#new' # route required for language switch

    resources :groups do
      member do
        scope module: 'census_evaluation' do
          get 'census/dachverband' => 'dachverband#index'
          get 'census/mitgliederorganisation' => 'mitgliederorganisation#index'
          get 'census/group' => 'group#index'
          get 'census/jungschar' => 'group#index'
          get 'census/weitere_arbeitsgebiete' => 'group#index'
          get 'census/sport' => 'group#index'
          get 'census/ten_sing' => 'group#index'
        end

        get 'population' => 'population#index'
      end

      resource :member_counts, only: [:create, :edit, :update, :destroy]
      get 'member_counts' => 'member_counts#edit' # route required for language switch
    end
  end
end
