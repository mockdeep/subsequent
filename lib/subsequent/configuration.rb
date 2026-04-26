# frozen_string_literal: true

require "optparse"

# module to allow configuring various Subsequent settings
module Subsequent::Configuration
  class << self
    # return the debug setting
    def debug?
      @debug ||= false
    end

    # allow setting the debug setting
    attr_writer :debug

    # the list name to start in, set via --list on the command line
    attr_accessor :list_name

    # the tag to filter by on startup, set via --tag on the command line
    attr_accessor :tag_name

    # return the input stream, $stdin by def ault
    def input
      @input ||= $stdin
    end

    # allow setting the input stream, useful in tests
    attr_writer :input

    # return the output stream, $stdout by def ault
    def output
      @output ||= $stdout
    end

    # allow setting the output stream, useful in tests
    attr_writer :output

    # parse command line arguments
    def parse(args)
      @list_name = nil
      @tag_name = nil

      remaining = option_parser.parse(args)
      return if remaining.empty?

      raise ArgumentError, "Unknown argument: #{remaining.first}"
    rescue OptionParser::InvalidOption => e
      raise ArgumentError, "Unknown argument: #{e.args.first}"
    end

    private

    def option_parser
      OptionParser.new do |opts|
        opts.on("--debug") { @debug = true }
        opts.on("--list LIST") { |value| @list_name = value }
        opts.on("--tag TAG") { |value| @tag_name = value }
      end
    end
  end
end
