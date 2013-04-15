module ISeriesOnRails
  class IFS
    
    def self.read source_filename
      chunk_size = 1024*64 # 64K
      
      # get the as400 connection and open the file
      sys = AS400.get_instance.sys
      stream = com.ibm.as400.access.IFSFileInputStream.new sys, source_filename
      
      # read contents, close and return data
      buffer = Java::byte[ chunk_size ].new
      bytes_read = stream.read buffer
      output = String.from_java_bytes buffer
      
      while bytes_read > 0 do
        bytes_read = stream.read buffer
        output += String.from_java_bytes buffer
      end
      
      stream.close
      
      output
    end
    
    def self.copy source_filename, target_filename
      chunk_size = 1024*64 # 64K
      
      # get the as400 connection and open the file
      sys = AS400.get_instance.sys
      stream = com.ibm.as400.access.IFSFileInputStream.new sys, source_filename
      
      f = File.open target_filename, 'w'
      
      # read contents, close and return data
      buffer = Java::byte[ chunk_size ].new
      bytes_read = stream.read buffer
      f.write String.from_java_bytes buffer
      
      total_bytes = bytes_read
      
      while bytes_read > 0 do
        bytes_read = stream.read buffer
        f.write String.from_java_bytes buffer
        total_bytes += bytes_read
      end
      
      f.close
      stream.close
      
      total_bytes
    end
  end
  
end