# frozen_string_literal: true

RSpec.describe Subsequent::Modes::Browse do
  include Subsequent::DisplayHelpers

  describe ".commands" do
    it "shows the browse subcommand hints" do
      hints = "(#{cyan("l")})ane (#{cyan("c")})ard chec(#{cyan("k")})list"

      expect(described_class.commands(make_state)).to include(hints)
    end

    it "shows cancel hint" do
      cancel = "(#{cyan("q")}) to cancel"

      expect(described_class.commands(make_state)).to include(cancel)
    end
  end

  describe ".handle_input" do
    it "returns state with Normal mode when input is q" do
      state = make_state
      mock_input("q")

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Modes::Normal))
    end

    it "returns state unchanged when input is something else" do
      state = make_state
      mock_input("z")

      expect(described_class.handle_input(state)).to eq(state)
    end
  end
end
