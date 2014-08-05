require 'spec_helper'
require 'csv'

describe Export::Csv::MemberCount do

  context '.export' do
    let(:csv) { CSV.parse(export, headers: true, col_sep: ';') }

    it 'has translated headers' do
      csv.headers.should eq ["Jahr", "Name", "Adresse", "Ort", "PLZ",
                             "Mitgliederorganisation",
                             "Total Mitglieder m", "Total Mitglieder w",
                             "1988 m", "1988 w", "1997 m", "1997 w",
                             "1998 m", "1998 w", "1999 m", "1999 w",
                             "2000 m", "2000 w", "Jahrgang unbekannt m", "Jahrgang unbekannt w" ]
    end

    it 'includes data for whole year' do
      csv['Name'].should eq ['Burgdorf', 'Zürich 10', 'Altstetten-Albisrieden']
      csv['Total Mitglieder m'].should eq ['5', '9', '3']
      csv['1998 m'].should eq ['3', nil, '1']
    end

    context 'for mitgliederorganisation' do
      let(:csv) { CSV.parse(export(mitgliederorganisation: groups(:be)), headers: true, col_sep: ';') }

      it 'only includes rows for member_counts associated with this mitgliederorganisation' do
        csv['Name'].should eq ['Burgdorf']
      end
    end
  end

  context '#years' do
    it 'is built from born_in and includes :unknown' do
      count.years.should eq [1988, 1997, 1998, 1999, 2000, :unknown]
    end
  end

  context '#attributes' do
    it 'includes static attributes and dynamic year range' do
      count.attributes.should eq [:year, :name, :address, :town, :zip_code, :mitgliederorganisation,
                                  :m_total, :f_total,
                                  :m_1988, :f_1988, :m_1997, :f_1997, :m_1998, :f_1998,
                                  :m_1999, :f_1999, :m_2000, :f_2000,
                                  :m_unknown, :f_unknown]
    end
  end

  context '#list' do
    it 'is built based on supplied counts' do
      count(year: 2012).list.should have(3).items
      count(mitgliederorganisation: groups(:zhshgl)).list.should have(2).items
      count(mitgliederorganisation: groups(:be)).list.should have(1).items
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
      entry.name.should eq 'Jungschar Burgdorf'
      entry.address.should eq 'Dorfplatz 1'
      entry.zip_code.should eq 3455
      entry.town.should eq 'Burgdorf'
    end

    it 'has mitgliederorganisation and year set' do
      entry.year.should eq 2012
      entry.mitgliederorganisation.should eq 'Cevi Region Bern'
    end

    it 'has total counts set' do
      entry.m_total.should eq 5
      entry.f_total.should eq 7
    end

    it 'has year based counts sets' do
      entry.m_1998.should eq 3
      entry.f_1998.should eq 6
      entry.m_2000.should eq 2
      entry.f_2000.should eq 1
    end

    it 'has unkown counts set if present' do
      MemberCount.where(group: group, born_in: 2000).first.update_attribute(:born_in, nil)
      entry.m_unknown.should eq 2
      entry.f_unknown.should eq 1
    end
  end

  def count(conditions = { year: 2012 })
    Export::Csv::MemberCount.new(MemberCount.where(conditions))
  end

  def export(conditions = { year: 2012 })
    Export::Csv::MemberCount.export(MemberCount.where(conditions))
  end

end
