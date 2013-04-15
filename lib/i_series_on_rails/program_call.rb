module ISeriesOnRails
  
  class ProgramCall
    @@pcml_path = ''
    
    # when a method is called on this object, it won't exist so this method will get executed, it will init
    #  the program call object, set properties and return
    def method_missing sym, *args, &block
      if args[0].class.name == 'Hash'
        return run_rpg_program sym.to_s, args[0]
      else
        return nil
      end
    end
    
    def run_rpg_program rpg_program_name, args={}
      sys = AS400.get_instance.sys
      
      xml = "lib.pcml.#{rpg_program_name}.pcml"
      pcml = com.ibm.as400.data.ProgramCallDocument.new sys, xml
      
      args.each do |key, val|
        pcml.setValue "#{rpg_program_name}.#{key.to_s}", val
      end
      
      return_code = pcml.callProgram rpg_program_name
      
      # Don't bother to create an unstance of AS400Result unless the rpg program executed successfuly.
      return false unless return_code
      
      x = ProgramCallResult.new rpg_program_name, pcml, return_code
      return x
    end
    
    def self.run rpg_program_name, args={}
      x = ProgramCall.new
      return x.run_rpg_program( rpg_program_name.to_s, args )
    end
    
    # I think nesting this inside the AS400 class is like making it a private class, 
    #  only intended to have instances creaed from within the AS400 class
    class ProgramCallResult
      attr_accessor :program, :return_code, :pcml
      
      def initialize rpg_program_name, pcml, return_code
        self.program = rpg_program_name
        self.pcml = pcml
        self.return_code = return_code
      end
      
      # return value from the program call
      def to_i
        pcml.getIntReturnValue
      end
      
      # act like a hash, return output    
      def [] key
        self.pcml.get_value( "#{program}.#{key.to_s}" )
      end
      
      def method_missing sym, *args, &block
        self.pcml.get_value( "#{program}.#{sym.to_s}" )
      rescue
        super
      end
      
      alias_method :to_bool, :return_code
      alias_method :to_b, :return_code
    end
  end
  
end