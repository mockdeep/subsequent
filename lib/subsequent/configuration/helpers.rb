# frozen_string_literal: true

# helper methods for accessing configuration
module Subsequent::Configuration::Helpers
  # return the configured input
  def input
    Subsequent::Configuration.input
  end

  # return the configured output
  def output
    Subsequent::Configuration.output
  end
end
