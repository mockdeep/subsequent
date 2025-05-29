# frozen_string_literal: true

# base helpers for modes
module Subsequent::Modes::Base
  # handle input for the mode
  def handle_input(state)
    output.print(commands(state))

    text = input.public_send(self::INPUT_METHOD).to_s.squish

    option = options.find { |option| option.match?(state, text) }
    option ? option.call(state, text) : state
  end

  # return the options available for the mode
  def options
    self::OPTIONS.map { |symbol| Subsequent::Options.fetch(symbol) }
  end
end
