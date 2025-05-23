# frozen_string_literal: true

# module to allow configuring various Subsequent settings
module Subsequent::Configuration
  class << self
    # return the debug setting
    def debug?
      @debug ||= false
    end

    # allow setting the debug setting
    attr_writer :debug

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
      args.each do |arg|
        case arg
        when "--debug"
          @debug = true
        else
          raise ArgumentError, "Unknown argument: #{arg}"
        end
      end
    end
  end
end
