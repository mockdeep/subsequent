# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: [:spec, :rubocop]

desc "Start irb with Subsequent loaded"
task :console do
  require "irb"
  require "irb/completion"
  require_relative "lib/subsequent"

  ARGV.clear
  IRB.start
end
