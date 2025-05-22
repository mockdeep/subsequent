# frozen_string_literal: true

# do nothing, just return state
module Subsequent::Options::Noop
  # return true, default to this when no other option matches
  def self.match?(*)
    true
  end

  # return state unchanged
  def self.call(state, _text)
    state
  end
end
