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
  task :full => ['test_project:generate', 'cucumber', 'test_project:destroy']
end

namespace :test_project do
  desc 'Suspend a new project. Pass REPO=... to change the Suspenders repo.'
  task :generate do
    FileUtils.rm_rf(TEST_PROJECT)
    sh 'ruby', 'bin/da-suspenders', 'create', TEST_PROJECT, ENV['REPO'].to_s
  end

  desc 'Remove a suspended project'
  task :destroy do
    FileUtils.cd TEST_PROJECT
    sh "rake db:drop RAILS_ENV=development"
    sh "rake db:drop RAILS_ENV=test"
    FileUtils.cd '..'
    FileUtils.rm_rf TEST_PROJECT
  end
end

desc 'Run the test suite'
task :default => ['test:full']

