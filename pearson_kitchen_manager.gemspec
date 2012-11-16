# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pearson_kitchen_manager/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Dave Shapiro"]
  gem.email         = ["dss.shapiro@gmail.com"]
  gem.description   = %q{API wrapper for Pearson Kitchen Manager}
  gem.summary       = %q{API wrapper for Pearson Kitchen Manager}
  gem.homepage      = "https://github.com/dsshap/pearson_kitchen_manager"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  # gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pearson_kitchen_manager"
  gem.require_paths = ["lib"]
  gem.version       = PearsonKitchenManager::VERSION

  gem.add_dependency('httparty')
  gem.add_dependency('json')

  gem.add_development_dependency('debugger')
  gem.add_development_dependency("rspec")
end
