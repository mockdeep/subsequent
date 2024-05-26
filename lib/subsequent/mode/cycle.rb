# frozen_string_literal: true

# Cycle mode functionality
module Subsequent::Mode::Cycle
  extend Subsequent::TextFormatting

  # cycle mode commands
  def self.commands(state)
    state => { checklist:, checklist_items: }

    string = [
      "move first",
      checklist_items && "(#{cyan("i")})tem,",
      checklist && "(#{cyan("l")})ist or",
      "(#{cyan("c")})ard to the end"
    ].compact.join(" ")

    [string, "(#{cyan("q")}) to cancel"]
  end
end
