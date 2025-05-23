# frozen_string_literal: true

# do nothing, just return state
module Subsequent::Options::Noop
  class << self
    # return true, def ault to this when no other option matches
    def match?(*)
      true
    end

    # return state unchanged
    def call(state, _text)
      state
    end
  end
end
