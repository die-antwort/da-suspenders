require "bundler"
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

#############################################################################
#
# Testing functions
#
#############################################################################

RSpec::Core::RakeTask.new(:spec)

TEST_PROJECT = "test_project"

desc "Generate and test projects with Active Record and Mongoid"
task :test => ['test:active_record', 'test:mongoid']

namespace :test do
  desc "Generate and test a project with Active Record"
  task :active_record do
    puts "\n=== Generating and testing a project with Active Record ==="
    Rake::Task["test_project:generate_active_record"].invoke
    sh "bundle exec rake spec"
  end

  desc "Generate and test a project with Mongoid"
  task :mongoid do
    Rake::Task["test_project:generate_mongoid"].invoke
    sh "bundle exec rake spec"
  end
end
  
    
namespace :test_project do
  desc 'Generate a new test project with ActiveRecord. Pass REPO=... to change the Suspenders repo (defaults to dir with Rakefile).'
  task :generate_active_record => :clean_env do
    generate_test_project(:with_mongoid => false)
  end

  desc 'Generate a new test project with Mongoid. Pass REPO=... to change the Suspenders repo (defaults to dir with Rakefile).'
  task :generate_mongoid => :clean_env do
    generate_test_project(:with_mongoid => true)
  end

  desc 'Remove test project'
  task :destroy => :clean_env do
    FileUtils.cd TEST_PROJECT
    sh "bundle exec rake db:drop"
    FileUtils.cd '..'
    FileUtils.rm_rf TEST_PROJECT
  end
end

task :clean_env do
  # Make sure to have a non-bundled ENV for generating the test project, even when running via "bundle exec rake ..."
  ENV["RUBYOPT"] = nil
  ENV["BUNDLE_GEMFILE"] = nil
end

def generate_test_project(options)
  FileUtils.rm_rf(TEST_PROJECT)
  repo = (ENV['REPO'] || "file://#{Dir.pwd}").to_s
  with_mongoid = options[:with_mongoid] ? "--with-mongoid" : ""
  sh 'ruby', 'bin/da-suspenders', 'create', TEST_PROJECT, with_mongoid, repo
end

