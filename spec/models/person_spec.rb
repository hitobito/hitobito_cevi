# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe Person do

  context 'PUBLIC ATTRS' do
    it 'contains parent fields' do
      expect(Person::PUBLIC_ATTRS).to include(:salutation_parents)
      expect(Person::PUBLIC_ATTRS).to include(:name_parents)
    end
  end

  context 'canton_label' do

    it 'is blank for nil value' do
      expect(Person.new.canton_label).to be_blank
    end

    it 'is blank for blank value' do
      expect(Person.new(canton: '').canton_label).to be_blank
    end

    it 'is locale specific value for valid key' do
      expect(Person.new(canton: 'be').canton_label).to eq 'Bern'
    end
  end

end
