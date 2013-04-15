require 'spec_helper'

describe ISeriesOnRails::StoreDateAsInteger do
  
  it 'should dump a string date as an integer' do
    d = '2012-07-07'
    r = ISeriesOnRails::StoreDateAsInteger.dump d
    r.should eq 20120707
  end
  
  it 'should dump a string date (with slashes) as an integer' do
    d = '2012/07/07'
    r = ISeriesOnRails::StoreDateAsInteger.dump d
    r.should eq 20120707
  end
  
  it 'should dump a date as an integer' do
    d = Date.new 2012, 07, 07
    r = ISeriesOnRails::StoreDateAsInteger.dump d
    r.should eq 20120707
  end
  
  it 'should dump a date as an integer' do
    d = DateTime.new 2012, 07, 07, 12, 01, 01
    r = ISeriesOnRails::StoreDateAsInteger.dump d
    r.should eq 20120707
  end
  
  it 'should dump an unspported object as a 0' do
    d = Hash.new
    r = ISeriesOnRails::StoreDateAsInteger.dump d
    r.should eq 0
  end
  
  it 'should load an integer as a date' do
    d = 20120707
    r = ISeriesOnRails::StoreDateAsInteger.load d
    r.class.name.should eq 'Date'
    r.year.should eq 2012
    r.month.should eq 7
    r.day.should eq 7
    
    d = 20121031
    r = ISeriesOnRails::StoreDateAsInteger.load d
    r.class.name.should eq 'Date'
    r.year.should eq 2012
    r.month.should eq 10
    r.day.should eq 31
  end 
  
  it 'should load a 0 as nil' do
    d = 0
    r = ISeriesOnRails::StoreDateAsInteger.load d
    r.should be_nil
  end
  
end
