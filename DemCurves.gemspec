# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name = 'dem-curves'
  spec.version = '0.0.1'
  spec.summary = 'A library for generating bezier curve based paths from control_points. It can be used with Rubygame'
  spec.author = 'Huba Nagy'
  spec.email = '12huba@gmail.com'
  
  spec.files = 'git ls-files'.split($/)
  spec.require_paths = ['lib']
end