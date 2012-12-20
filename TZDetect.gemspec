# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'tzdetect/version'


Gem::Specification.new do |gem|
  gem.name          = "tzdetect"
  gem.version       = TZDetect::VERSION
  gem.authors       = ["Bojan Milosavljevic "]
  gem.email         = ["milboj@gmail.com"]
  gem.description   = %q{Detects  timezone by address or location using google or geoname web service}
  gem.summary       = %q{Easy way to detect time zone by  address or location }
  gem.homepage      = "https://github.com/milboj/tzdetect"
  gem.required_ruby_version = ">= 1.9.2"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'tzinfo', '>= 0.3.33'
  gem.add_dependency 'json', '>= 1.7'
end
