# frozen_string_literal: true

# helper methods for accessing configuration
module Subsequent::Configuration::Helpers
  # return the debug setting
  def debug?
    Subsequent::Configuration.debug?
  end

  # clear the screen if not in debug mode
  def clear_screen
    output.clear_screen unless debug?
  end

  # return the configured input
  def input
    Subsequent::Configuration.input
  end

  # return the configured output
  def output
    Subsequent::Configuration.output
  end
end
