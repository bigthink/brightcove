# -*- encoding: utf-8 -*-

require 'lib/brightcove/version'

Gem::Specification.new do |s|
  s.name        = 'brightcove'
  s.version     = Brightcove::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ 'Jonah Burke' ]
  s.email       = [ 'jonah@bigthink.com' ]
  s.homepage    = ''
  s.summary     = 'A ruby client for the Brightcove Media API'
  s.description = s.summary

  s.required_ruby_version = '>= 1.8.7'
  s.required_rubygems_version = '>= 1.3.5'

  s.files        = Dir.glob( 'lib/**/*' )
  s.require_path = 'lib'

  s.add_dependency 'json'
  s.add_development_dependency 'rdoc'
end