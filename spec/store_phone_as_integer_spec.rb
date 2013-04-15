require 'spec_helper'

describe ISeriesOnRails::StorePhoneAsInteger do
  
  it 'should dump a phone as an integer' do
    p = '289-637-8969'
    r = ISeriesOnRails::StorePhoneAsInteger.dump p
    r.should eq 2896378969
  end
  
  it 'should dump a phone as an integer (bigger number)' do
    p = '989-637-8969'
    r = ISeriesOnRails::StorePhoneAsInteger.dump p
    r.should eq 9896378969
  end
  
  it 'should load an integer as a phone number' do
    p = 2896378969
    r = ISeriesOnRails::StorePhoneAsInteger.load p
    r.should eq "289-637-8969"
  end
  
  it 'should load a 0 as a nil' do
    p = 0
    r = ISeriesOnRails::StorePhoneAsInteger.load p
    r.should be_nil
  end
  
end
