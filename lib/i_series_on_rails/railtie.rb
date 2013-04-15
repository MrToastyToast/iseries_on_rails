module ISeriesOnRails
  
  class Railtie < Rails::Railtie
    initializer "iseries_on_rails.initstuff" do
      init_jars
      init_as400
    end
    
    def init_jars
      # add jars and pcml files to the class path
      for file in Dir.glob( Rails.root.to_s + '/lib/jars/*.jar' )
        $CLASSPATH << file
      end
      $CLASSPATH << Rails.root.to_s + "lib/pcml"
    end
    
    def init_as400
      # create an instance of the AS400 object if host user and pass are defined in config.
      args = []
       
      args << Rails.application.config.as400_hostname if Rails.application.config.respond_to? 'as400_hostname'
      args << Rails.application.config.as400_username if Rails.application.config.respond_to? 'as400_username'
      args << Rails.application.config.as400_password if Rails.application.config.respond_to? 'as400_password'
      args << Rails.application.config.as400_proxy    if Rails.application.config.respond_to? 'as400_proxy'
      
      if args.size > 0
        ISeriesOnRails::AS400.get_instance( *args )
      else
        nil
      end
    end
    
  end
  
end

module ActiveRecord
  class Base

    def self.serialize_date_as_integer meth
      serialize meth, ISeriesOnRails::StoreDateAsInteger

      define_method meth.to_s+"=" do |v|
        @attributes[meth.to_s][:value] = v
      end
    end

    def self.serialize_phone_as_integer meth
      serialize meth, ISeriesOnRails::StorePhoneAsInteger

      define_method meth.to_s+"=" do |v|
        @attributes[meth.to_s][:value] = v
      end
    end

  end
end