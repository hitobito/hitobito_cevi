# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe PopulationController do

  let(:jungschar) { groups(:jungschar_zh10) }
  let(:froeschli) { groups(:jungschar_zh10_froeschli) }
  let(:aranda) { groups(:jungschar_zh10_aranda) }


  let!(:leader) { Fabricate(Group::Jungschar::Abteilungsleiter.name.to_sym, group: jungschar).person }
  let!(:werbung) { Fabricate(Group::Jungschar::Werbung.name.to_sym, group: jungschar).person }
  let!(:freier_ma) { Fabricate(Group::Jungschar::FreierMitarbeiter.name.to_sym, group: jungschar).person }
  let!(:deleted) { Fabricate(Group::Jungschar::Werbung.name.to_sym, group: jungschar, deleted_at: 1.year.ago) }
  let!(:group_leader) { Fabricate(Group::Froeschli::Froeschlihauptleiter.name.to_sym, group: froeschli, person: werbung).person }
  let!(:child) { Fabricate(Group::Froeschli::Teilnehmer.name.to_sym, group: froeschli).person }

  before { sign_in(leader) }

  describe 'GET index' do
    before { get :index, id: jungschar.id }

    describe 'groups' do
      subject { assigns(:groups) }

      it { is_expected.to eq([jungschar, froeschli] + valid_sub_groups) }

      def valid_sub_groups
        %w(aranda jakob salomo samson sinai zephanja zion leitungsteam).map do |name|
          groups(:"jungschar_zh10_#{name}")
        end
      end
    end

    describe 'people by group' do
      subject { assigns(:people_by_group) }

      it { expect(subject[jungschar].collect(&:to_s)).to match_array([leader, people(:al_zh10), werbung].collect(&:to_s)) }
      it { expect(subject[froeschli].collect(&:to_s)).to match_array([group_leader, child, people(:child)].collect(&:to_s)) }
      it { expect(subject[aranda]).to be_nil }
    end

    describe 'complete' do
      subject { assigns(:people_data_complete) }

      it { is_expected.to be_falsey }
    end
  end

  describe 'GET index does not include deleted groups' do
    before do
      groups(:jungschar_zh10_aranda).destroy
      get :index, id: jungschar.id
    end

    subject { assigns(:groups) }

    it { is_expected.not_to include aranda }
  end
end
