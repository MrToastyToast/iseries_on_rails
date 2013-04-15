require File.expand_path("../lib/i_series_on_rails/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brian Kulyk"]
  gem.email         = ["brian@kulyk.ca"]
  gem.description   = %q{Use rails in conjuction with an ISeries}
  gem.summary       = %q{Use rails in conjuction with an ISeries}
  gem.homepage      = "https://github.com/bkulyk/iseries_on_rails"

  gem.files         = `git ls-files`.split($\)
  #gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  #gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "iseries_on_rails"
  gem.require_paths = ["lib"]
  gem.version       = ISeriesOnRails::VERSION

  gem.add_runtime_dependency "rake"
  gem.add_runtime_dependency "activesupport", "> 3.0.1"

  gem.add_development_dependency "bundler",      "~> 1.0"
  gem.add_development_dependency "rspec",        "~> 2.6"
end