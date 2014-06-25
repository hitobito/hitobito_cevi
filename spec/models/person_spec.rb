require 'spec_helper'

describe Person do

  context 'canton_value' do

    it 'is blank for nil value' do
      Person.new.canton_value.should be_blank
    end

    it 'is blank for blank value' do
      Person.new(canton: '').canton_value.should be_blank
    end

    it 'is locale specific value for valid key' do
      Person.new(canton: 'be').canton_value.should eq 'Bern'
    end
  end

end
