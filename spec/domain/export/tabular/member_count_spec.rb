# encoding: UTF-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'
require 'csv'

describe Export::Tabular::MemberCount do

  context '.export' do
    let(:csv) { CSV.parse(export, headers: true, col_sep: ';') }

    it 'has translated headers' do
      expect(csv.headers).to eq ["Jahr", "Name", "Adresse", "Ort", "PLZ",
                                 "Mitgliederorganisation",
                                 "Total Mitglieder m", "Total Mitglieder w",
                                 "1988 m", "1988 w", "1997 m", "1997 w",
                                 "1998 m", "1998 w", "1999 m", "1999 w",
                                 "2000 m", "2000 w", "Jahrgang unbekannt m", "Jahrgang unbekannt w" ]
    end

    it 'includes data for whole year' do
      expect(csv['Name']).to eq ['Altstetten-Albisrieden', 'Burgdorf', 'Zürich 10']
      expect(csv['Total Mitglieder m']).to eq ['3', '5', '9']
      expect(csv['1998 m']).to eq ['1', '3', nil]
    end

    context 'for mitgliederorganisation' do
      let(:csv) { CSV.parse(export(mitgliederorganisation: groups(:be)), headers: true, col_sep: ';') }

      it 'only includes rows for member_counts associated with this mitgliederorganisation' do
        expect(csv['Name']).to eq ['Burgdorf']
      end
    end
  end

  context '#years' do
    it 'is built from born_in and includes :unknown' do
      expect(count.years).to eq [1988, 1997, 1998, 1999, 2000, :unknown]
    end
  end

  context '#attributes' do
    it 'includes static attributes and dynamic year range' do
      expect(count.attributes).to eq [:year, :name, :address, :town, :zip_code, :mitgliederorganisation,
                                      :m_total, :f_total,
                                      :m_1988, :f_1988, :m_1997, :f_1997, :m_1998, :f_1998,
                                      :m_1999, :f_1999, :m_2000, :f_2000,
                                      :m_unknown, :f_unknown]
    end
  end

  context '#list' do
    it 'is built based on supplied counts' do
      expect(count(year: 2012).list).to have(3).items
      expect(count(mitgliederorganisation: groups(:zhshgl)).list).to have(2).items
      expect(count(mitgliederorganisation: groups(:be)).list).to have(1).items
    end
  end

  context 'first item of list' do
    let(:entry) { count(mitgliederorganisation: groups(:be)).list.first }
    let(:group) { groups(:jungschar_burgd) }

    before { group.update_attributes(name: 'Jungschar Burgdorf',
                                     address: 'Dorfplatz 1',
                                     zip_code: 3455,
                                     town: 'Burgdorf') }

    it 'has group attributes attributes set' do
      expect(entry.name).to eq 'Jungschar Burgdorf'
      expect(entry.address).to eq 'Dorfplatz 1'
      expect(entry.zip_code).to eq 3455
      expect(entry.town).to eq 'Burgdorf'
    end

    it 'has mitgliederorganisation and year set' do
      expect(entry.year).to eq 2012
      expect(entry.mitgliederorganisation).to eq 'Cevi Region Bern'
    end

    it 'has total counts set' do
      expect(entry.m_total).to eq 5
      expect(entry.f_total).to eq 7
    end

    it 'has year based counts sets' do
      expect(entry.m_1998).to eq 3
      expect(entry.f_1998).to eq 6
      expect(entry.m_2000).to eq 2
      expect(entry.f_2000).to eq 1
    end

    it 'has unkown counts set if present' do
      MemberCount.where(group: group, born_in: 2000).first.update_attribute(:born_in, nil)
      expect(entry.m_unknown).to eq 2
      expect(entry.f_unknown).to eq 1
    end
  end

  def count(conditions = { year: 2012 })
    Export::Tabular::MemberCount.new(MemberCount.where(conditions))
  end

  def export(conditions = { year: 2012 })
    Export::Tabular::MemberCount.csv(MemberCount.where(conditions).order(:id))
  end

end
