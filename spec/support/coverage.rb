# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  enable_coverage :branch
  add_filter "_spec.rb"
  add_group "Lib", "lib"
  add_group "Support", "spec/support"
end

SimpleCov.minimum_coverage(line: 89, branch: 31)
