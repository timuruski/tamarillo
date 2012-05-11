#!/usr/bin/env rake
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
# require 'cucumber'
require 'cucumber/rake/task'

desc "Interactive pomodoro console"
task :console do
  exec("irb -Ilib -r'bundler/setup' -r'tamarillo'")
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--color'
end

Cucumber::Rake::Task.new(:features) do |t|
  tag_opts = ' --tags ~@pending'
  tag_opts = " --tags #{ENV['TAGS']}" if ENV['TAGS']
  t.cucumber_opts = "features --format progress -x -s#{tag_opts}"
  t.fork = false
end
task :default => [:spec, :features]
