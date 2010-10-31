require 'rubygems'
require 'rake/testtask'
require 'rdoc/task'
require 'lib/brightcove'

task :default => :test

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

RDoc::Task.new do |task|
  task.title = 'Brightcove'
  task.main = 'README'
  task.rdoc_dir = 'doc'
  task.rdoc_files.include 'README', 'lib/**/*.rb'
end

desc 'Build gem'
task :build do
  system "gem build brightcove.gemspec"
end