module ISeriesOnRails

  module MultiMember

    def self.included base
      # when this is included add the extend as well
      base.class_eval do 
        extend MultiMember
      end
    end

    # db2 supports having multiple members, this method is to allow switching to a different member
    def use_member member_name
      t = ( self.class.name == 'Class' ? table_name : self.class.table_name )
      table = t.upcase.split(".").last

      command = "OVRDBF FILE(#{table}) MBR(#{member_name}) OVRSCOPE(*JOB)"
      Rails.logger.info "Use member #{member_name} for #{self}"

      # I wish I didn't have to use the raw_connection like this, but the statement gives a error 
      #  about an invalid cursor unless it's done this way
      x = connection.raw_connection.connection.create_statement      

      # execute the command
      size = command.size.to_s.rjust 10, '0'
      sql = "CALL QSYS.QCMDEXC('#{command}',#{size}.00000)"
      Rails.logger.info sql
      x.execute sql
    end
  end

  module UpcaseStrings
    
    def self.included base
      base.before_save :upcase_all_strings
    end
    
    def upcase_all_strings
      column_types = Hash[ self.class.columns.map { |c| [c.name, c.type] } ]
      attributes.each do |k,v|
        # capitalize the value if the type is text or string
        self.send( "#{k}=".to_sym, v.to_s.upcase ) if[ :text, :string ].include? column_types[ k ]
      end
    end
    
  end
  
  module FakeAutoIncrement
    
    # attach the callback
    def self.included(base)
      base.before_create :get_fake_auto_increment_id
    end
    
    def get_fake_auto_increment_id
      pk = self.class.primary_key
      # obtain last record
      query = self.class.select( pk.to_sym ).limit( 1 ).order( "#{pk} DESC" )
      result = ActiveRecord::Base.connection.execute( query )
      # assume 0 if there are no rows
      begin
        id = result.first[pk].to_i
      rescue
        id = 0
      end
      # set the id to whatever we found +1
      self.send( "#{pk}=".to_sym, id+1 ) 
    end
  end
  
  module Model
    
    # attach the callback
    def self.included(base)
      base.after_initialize :strip_strings
      base.after_find :strip_strings
      base.before_save :replace_nil
    end
    
    def replace_nil
      column_types = Hash[ self.class.columns.map { |c| [c.name, c.type] } ]
      attributes.each do |k,v|
        
        if v.nil?
          case column_types[ k ]
          when :text
            self.send( "#{k}=".to_sym, '' )
          when :string
            self.send( "#{k}=".to_sym, '' )
          when :integer
            self.send( "#{k}=".to_sym, 0 )
          when :decimal
            self.send( "#{k}=".to_sym, 0 )
          end
        end
        
      end
      
    end

    # our database is using char fields instead of varchar, so I need to strip
    #  the right hand side of the strings  
    def strip_strings
      attributes.each do |k,v|
        if v.class == String
          self.send( "#{k}=".to_sym, v.rstrip )
        end
      end
    end
    
  end
  
end