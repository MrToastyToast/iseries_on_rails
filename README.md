# ISeriesOnRails #

Gem to make developing rails apps easier when working with DB2 on the ISeries/AS400

## Installation ##


in your Gemfile:

    gem 'iseries_on_rails', :git=>'https://github.com/bkulyk/iseries_on_rails'

## Usage ##

### Models ###

    class Widget < ActiveRecord::Base
      include ISeriesOnRails::Model # will automatically strip white space from char fields, and will replace nil values with empty strings
      include ISeriesOnRails::UpcaseString # will automatically upcase strings (char/varchar) fields before saveing
      include ISeriesOnRails::FakeAutoIncrement # will automatically fetch the highest value in the primary keys's field and incremnt by 1
    end

#### Serializing Dates as Integers ####

By convention our RPG devlopers store dates in integer fields, which is inconventient in rails, so 
ISeriesOnRails has a method to serialize and unserialize dates as integers.

example:
    Date.new( 2013, 4, 15 ) is stored as the integer: 20130415

usage:

    class Widget < ActiveRecord::Base
      serialize_date_as_integer :some_field
    end

#### Serializing Phone Number as Integers ####

    class Widget < ActiveRecord::Base
      serialize_phone_as_integer :some_field
    end

#### Serializing Time as Integers ####

Time is stored as a 6 digit number (201221), this will convert it into more human readable format: 20:12:21

class Widget < ActiveRecord::Base
  serialize_time_as_integer :some_field
end

### Program Calls ###

You can use ISeriesOnRails to execute RPG programs.  To do so, save a .pcml file in "#{Rails.root}/lib/pcml/"
describing the RPG program's name and location as well as input and output parameters.

example:

    <pcml version="1.0">
      <!-- describes how the xtname RPG program works -->
      <program name="person_name" path="/QSYS.lib/SOMELIB.lib/XTNAME.pgm">
        <data name="user_id"    type="char" length="9"  usage="inputoutput"  />
        <data name="last_name"  type="char" length="30" usage="inputoutput" init='' />
        <data name="first_name" type="char" length="30" usage="inputoutput" init='' />
      </program>
    </pcml>

Once the .pcml file is in place you can execute the rpg program like:

    input_params = { user_id => "0000000099" }
    res = ISeriesOnRails::ProgramCall.run :person_name, input_params

    puts res[:last_name]  # outputs: Jones
    puts res['last_name'] # outputs: Jones
    puts res.last_name    # outputs: Jones

For more info on .pcml files read: [Building iSeries program calls with PCML](http://publib.boulder.ibm.com/infocenter/iseries/v5r3/index.jsp?topic=%2Frzahh%2Fpcmlproc.htm)