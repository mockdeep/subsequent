# frozen_string_literal: true

# base helpers for modes
module Subsequent::Modes::Base
  # handle input for the mode
  def handle_input(state)
    output.print(commands(state))

    text = input.public_send(self::INPUT_METHOD).to_s.squish

    option = self::OPTIONS.find { |option| option.match?(state, text) }
    option ? option.call(state, text) : state
  end
end
