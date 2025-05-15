# frozen_string_literal: true

# module to allow configuring various Subsequent settings
module Subsequent::Configuration
  # return the debug setting
  def self.debug?
    @debug = ENV["DEBUG"].present? if @debug.nil?
    @debug
  end

  # allow setting the debug setting
  def self.debug=(debug)
    @debug = debug
  end

  # return the input stream, $stdin by default
  def self.input
    @input ||= $stdin
  end

  # allow setting the input stream, useful in tests
  def self.input=(input)
    @input = input
  end

  # return the output stream, $stdout by default
  def self.output
    @output ||= $stdout
  end

  # allow setting the output stream, useful in tests
  def self.output=(output)
    @output = output
  end
end
