require "i_series_on_rails/railtie" if defined?(Rails)
require "active_support/dependencies/autoload"

module ISeriesOnRails
  extend ActiveSupport::Autoload

  autoload :Model
  autoload :VERSION
  autoload :StoreDateAsInteger
  autoload :StorePhoneAsInteger
  autoload :AS400
  autoload :IFS
  autoload :ProgramCall
  
end