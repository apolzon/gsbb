require 'bundler'
require 'rake/clean'
require 'rake/testtask'
require 'cucumber'
require 'cucumber/rake/task'
require 'rdoc/task'
require 'grit'

require "bundler/gem_tasks"

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format progress -x"
  t.fork = false
end

require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end
