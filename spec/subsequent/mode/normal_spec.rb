# frozen_string_literal: true

RSpec.describe Subsequent::Mode::Normal do
  describe ".handle_input" do
    it "returns the state with filter mode when input is f" do
      state = make_state
      mock_input("f")

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Mode::Filter))
    end
  end
end
