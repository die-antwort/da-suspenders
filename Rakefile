require "bundler"
require "cucumber/rake/task"

Bundler::GemHelper.install_tasks

#############################################################################
#
# Testing functions
#
#############################################################################

Cucumber::Rake::Task.new

TEST_PROJECT = "test_project"

namespace :test do
  desc "A full suspenders app's test suite"
  task :full => ['test_project:generate', 'cucumber']
end

namespace :test_project do
  desc 'Suspend a new project. Pass WITH_MONGOID=1 to use mongoid. Pass REPO=... to change the Suspenders repo (defaults to dir with Rakefile).'
  task :generate => :clean_env do
    FileUtils.rm_rf(TEST_PROJECT)
    repo = (ENV['REPO'] || "file://#{Dir.pwd}").to_s
    with_mongoid = ENV["WITH_MONGOID"] ? "--with-mongoid" : ""
    sh 'ruby', 'bin/da-suspenders', 'create', TEST_PROJECT, with_mongoid, repo
  end

  desc 'Remove a suspended project'
  task :destroy => :clean_env do
    FileUtils.cd TEST_PROJECT
    sh "bundle exec rake db:drop"
    FileUtils.cd '..'
    FileUtils.rm_rf TEST_PROJECT
  end
end

desc 'Run the test suite'
task :default => ['test:full']

task :clean_env do
  # Make sure to have a non-bundled ENV for generating the test project, even when running via "bundle exec rake ..."
  ENV["RUBYOPT"] = nil
  ENV["BUNDLE_GEMFILE"] = nil
end
