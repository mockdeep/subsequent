# frozen_string_literal: true

RSpec.describe Subsequent::Modes::Normal do
  describe ".handle_input" do
    it "refreshes the data when input is r" do
      state = make_state
      mock_input("r")
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      described_class.handle_input(state)

      expect(a_request(:get, /cards/)).to have_been_made.once
    end

    it "returns the state with filter mode when input is f" do
      state = make_state
      mock_input("f")

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Modes::Filter))
    end
  end
end
