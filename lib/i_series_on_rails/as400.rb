module ISeriesOnRails
  
  # Class to connect to the AS400 for program calls, file system reads, etc.
  class AS400
    attr_accessor :sys
    @@as400_instance = {}
    
    # establish a connection to the iseries/as400
    def initialize ip, username=nil, password=nil, proxy_server=nil
      args = [ ip ]
      args << username unless username.nil?
      args << password unless password.nil?
      args << proxy_server unless proxy_server.nil?
      self.sys = com.ibm.as400.access.AS400.new( *args )
    end
    
    # get the global instance of the AS400 connection object
    def self.get_instance ip=nil, username=nil, password=nil, proxy_server=nil, name=nil
      name = 'default' if name.nil?
      @@as400_instance[name] = AS400.new ip, username, password, proxy_server if @@as400_instance[name].nil?
      @@as400_instance[name]
    end
    
    # destroy the global instance of the AS400 connection object
    def self.close_instance
      name = 'default' if name.nil?
      @@as400_instance[name] = nil
    end
    
  end
  
end