# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tamarillo/version', __FILE__)

Gem::Specification.new do |gem|

  gem.name          = "tamarillo"
  gem.version       = Tamarillo::VERSION
  gem.authors       = ["Tim Uruski"]
  gem.email         = ["timuruski@gmail.com"]
  gem.description   = %q{Manage pomodoros from the command-line.}
  gem.summary       = %q{A command-line application for managing the pomodoro technique.}
  gem.homepage      = "https://github.com/timuruski/tamarillo"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'aruba', '~> 0.4.11'
  gem.add_development_dependency 'activesupport', '~> 3.0.0'
  gem.add_development_dependency 'fakefs', '~> 0.4.0'
  gem.add_development_dependency 'rspec', '~> 2.9.0'
  gem.add_development_dependency 'timecop', '~> 0.3.5'

  gem.add_runtime_dependency 'gli', '~> 1.6.0'
  gem.add_runtime_dependency 'multi_json', '~> 1.3.6'

end
