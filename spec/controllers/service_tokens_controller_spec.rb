# frozen_string_literal: true

#  Copyright (c) 2024, CEVI Schweiz. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe ServiceTokensController do
  let(:group) { groups(:dachverband) }
  let(:gs_group) { groups(:dachverband_gs) }

  context 'with show_donors permission (financials role)' do
    let(:person) do
      Fabricate(Group::DachverbandGeschaeftsstelle::Finanzverantwortlicher.name.to_sym,
                group: gs_group).person
    end

    before { sign_in(person) }

    it 'includes show_donors in permitted params and saves it' do
      token = Fabricate(:service_token, layer: group)
      patch :update, params: {
        group_id: group.id,
        id: token.id,
        service_token: { show_donors: true }
      }
      expect(token.reload.show_donors).to be true
    end

    it 'can clear show_donors' do
      token = Fabricate(:service_token, layer: group, show_donors: true)
      patch :update, params: {
        group_id: group.id,
        id: token.id,
        service_token: { show_donors: false }
      }
      expect(token.reload.show_donors).to be false
    end
  end

  context 'without show_donors permission (finance but not financials role)' do
    let(:person) do
      Fabricate(Group::DachverbandGeschaeftsstelle::Geschaeftsleiter.name.to_sym,
                group: gs_group).person
    end

    before { sign_in(person) }

    it 'ignores show_donors param and leaves it false' do
      token = Fabricate(:service_token, layer: group)
      patch :update, params: {
        group_id: group.id,
        id: token.id,
        service_token: { show_donors: true }
      }
      expect(token.reload.show_donors).to be false
    end
  end
end
