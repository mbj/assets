# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name        = 'mbj-assets'
  gem.version     = '0.0.6'
  gem.authors     = [ 'Markus Schirp' ]
  gem.email       = [ 'mbj@schirp-dso.com' ]
  gem.description = 'Playground for a small assets system'
  gem.summary     = gem.description
  gem.homepage    = 'https://github.com/mbj/assets'

  gem.require_paths    = [ 'lib' ]
  gem.files            = `git ls-files`.split("\n")
  gem.test_files       = `git ls-files -- spec`.split("\n")
  gem.extra_rdoc_files = %w[TODO]

  gem.add_runtime_dependency('adamantium',          '~> 0.0.8')
  gem.add_runtime_dependency('ice_nine',            '~> 0.8.0')
  gem.add_runtime_dependency('descendants_tracker', '~> 0.0.1')
  gem.add_runtime_dependency('concord',             '~> 0.1.1')
  gem.add_runtime_dependency('equalizer',           '~> 0.0.5')
  gem.add_runtime_dependency('response',            '~> 0.0.2')
  gem.add_runtime_dependency('request',             '~> 0.0.2')
  gem.add_runtime_dependency('abstract_type',       '~> 0.0.5')
  gem.add_runtime_dependency('anima',               '~> 0.0.5')
  gem.add_runtime_dependency('sass',                '~> 3.2.4')
  gem.add_runtime_dependency('coffee-script',       '~> 2.2.0')
end
