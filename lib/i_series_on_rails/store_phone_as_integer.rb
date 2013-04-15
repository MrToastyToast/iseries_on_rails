module ISeriesOnRails  
  
  class StorePhoneAsInteger
    
    def self.dump value
      value.to_s.tr('^0-9', '').to_i
    rescue
      0
    end
    
    def self.load value
      return nil if value == 0
      v = value.to_s
      v.scan( /(\d{3})(\d{3})(\d{4})/ ).join('-')
    rescue
      nil
    end
    
  end
  
end