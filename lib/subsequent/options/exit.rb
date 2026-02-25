# frozen_string_literal: true

# exit the program
module Subsequent::Options::Exit
  Subsequent::Options.register(self, :exit)

  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  class << self
    # return true if the text is "q", Ctrl+D, or Ctrl+C
    def match?(_state, text)
      ["q", "\u0004", "\u0003"].include?(text)
    end

    # print a goodbye message and exit
    def call(_state, _text)
      output.print(terminal_title(""))
      output.puts
      output.puts yellow("Goodbye!")
      throw(:quit)
    end
  end
end
