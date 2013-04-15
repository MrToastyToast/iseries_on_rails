module ISeriesOnRails

  class CommandCall

    def initialize command
      sys = AS400.get_instance.sys
      @command = com.ibm.as400.access.CommandCall.new sys, command
    end

    def run_command
      @command.run
    end

    def self.run command, args={}
      CommandCall.new( command ).run_command
    end
  end

end