# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name = 'DemCurves'
  gem.version = '0.0.1'
  gem.author = 'Huba Nagy'
  gem.email = '12huba@gmail.com'
  
  gem.files = 'git ls-files'.split($/)
  gem.require_paths = ['lib']
end