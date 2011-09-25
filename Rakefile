require "bundler/gem_tasks"
require 'rspec/core/rake_task'

gem 'rdoc'
require 'rdoc/task'

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "Retriever #{Retriever::VERSION}"
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.options << '--charset' << 'utf-8'
  rdoc.options << '--line-numbers'
  rdoc.main = 'README.rdoc'
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "./spec/**/*_spec.rb"
  t.rspec_opts = ['--color']
end
