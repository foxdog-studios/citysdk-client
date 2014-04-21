# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = 'citysdk-client'

  # If changed, also update lib/citysdk.rb
  gem.version       = '0.2'

  gem.authors       = ['Peter Sutton']
  gem.email         = ['foxxy@foxdogstudios.com']
  gem.description   = %q{Ruby client for the CitySDK API}
  gem.summary       = %q{Ruby client for the CitySDK API}
  gem.homepage      = "http://dev.citysdk.futureeverything.com/"
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('addressable', '~> 2.3.5')
  gem.add_dependency('dbf')
  gem.add_dependency('georuby', '~> 2.0.0')
  gem.add_dependency('faraday', '~> 0.8.5')
  gem.add_dependency('charlock_holmes', '~> 0.6.9.4')
  gem.add_dependency('nokogiri', '~> 1.6.1')
end

