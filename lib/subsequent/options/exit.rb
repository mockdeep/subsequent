# frozen_string_literal: true

# exit the program
module Subsequent::Options::Exit
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  # return true if the text is "q", Ctrl+D, or Ctrl+C
  def self.match?(_state, text)
    ["q", "\u0004", "\u0003"].include?(text)
  end

  # print a goodbye message and exit
  def self.call(_state, _text)
    output.puts
    output.puts yellow("Goodbye!")
    exit
  end
end
