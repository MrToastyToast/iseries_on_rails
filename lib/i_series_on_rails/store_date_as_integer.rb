module ISeriesOnRails

  class StoreDateAsInteger
    
    def self.dump value
      if value.respond_to? 'strftime'
        value.strftime( "%Y%0m%0d" ).to_i
      elsif value.is_a? String
        value.gsub( '-', '' ).gsub( '/', '' ).to_i
      elsif value.is_a? BigDecimal
        value.to_i.to_s.gsub( '-', '' ).gsub( '/', '' ).to_i
      elsif value.is_a? Integer
        value.to_s.gsub( '-', '' ).gsub( '/', '' ).to_i
      else
        0
      end
    end
    
    def self.load value
      Date.strptime( value.to_s, "%Y%m%d" )
    rescue
      nil
    end
    
  end
  
end
