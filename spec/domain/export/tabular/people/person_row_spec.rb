# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'
require 'csv'

describe Export::Tabular::People do

  let(:person) { people(:bulei) }
  let(:simple_headers) do
    ['Vorname', 'Nachname', 'Ceviname', 'Firmenname', 'Firma', 'Haupt-E-Mail', 'Adresse', 'PLZ',
     'Ort', 'Land', 'Geschlecht', 'Geburtstag', 'Rollen', 'Anrede Eltern', 'Name Eltern',
     'Ortsgruppe']
  end

  let(:list) { [person] }
  let(:data) { Export::Tabular::People::PeopleAddress.csv(list) }
  let(:csv)  { CSV.parse(data, headers: true, col_sep: Settings.csv.separator) }

  subject { csv }

  context 'export' do
    its(:headers) { should eq simple_headers }

    before do
      person.update_attributes(salutation_parents: 'Herr & Frau',
                               name_parents: 'Meier',
                               ortsgruppe_id: groups(:stadtzh).id)
    end

    context 'first row' do
      subject { csv[0] }

      its(['Vorname']) { should eq person.first_name }
      its(['Nachname']) { should eq person.last_name }
      its(['Haupt-E-Mail']) { should eq person.email }
      its(['Ort']) { should eq person.town }
      its(['Geschlecht']) { should eq person.gender_label }
      its(['Rollen']) { should eq 'Administrator/-in CEVI Schweiz' }
      its(['Anrede Eltern']) { should eq 'Herr & Frau' }
      its(['Name Eltern']) { should eq 'Meier' }
      its(['Ortsgruppe']) { should eq 'StZH' }
    end
  end

  context 'export_full' do
    its(:headers) { should include('Titel') }
    let(:data) { Export::Tabular::People::PeopleFull.csv(list) }

    before do
      person.update_attributes(canton: 'be',
                               confession: 'rk',
                               correspondence_language: 'de',
                               salutation: 'formal')

    end

    context 'first row' do
      subject { csv[0] }

      its(['Anrede']) { should eq 'Sie' }
      its(['Kanton']) { should eq 'Bern' }
      its(['Konfession']) { should eq 'Römisch-katholisch' }
      its(['Korrespondenzsprache']) { should eq 'de' }
    end
  end
end
