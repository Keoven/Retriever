# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "retriever/version"

Gem::Specification.new do |s|
  s.name        = 'retriever'
  s.version     = Retriever::VERSION
  s.authors     = ['Nelvin Driz']
  s.email       = ['ndriz@exist.com']
  s.homepage    = "http://github.com/Keoven/Retriever"
  s.summary     = %q{Retriever is a block result caching library.}
  s.description = %q{
    Retriever allows caching of the result of a block. It currently supports ruby memory storage and redis.
  }

  s.rubyforge_project = 'retriever'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Development
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'redis'
  s.add_development_dependency 'yajl-ruby'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'ruby-debug19'
  s.add_development_dependency 'simplecov'

  # Runtime
  s.add_runtime_dependency 'activesupport'
end
