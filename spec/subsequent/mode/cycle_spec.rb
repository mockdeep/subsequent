# frozen_string_literal: true

RSpec.describe Subsequent::Mode::Cycle do
  describe ".handle_input" do
    it "returns the state with normal mode when input is q" do
      state = make_state
      mock_input("q")

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Mode::Normal))
    end

    it "cycles the checklist item to the end when input is i" do
      mock_input("i")

      stub_request(:put, /checkItem/).to_return(body: api_checklist.to_json)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      described_class.handle_input(make_state(cards: [make_card_with_item]))

      expect(a_request(:put, /checkItem/)).to have_been_made.once
    end

    it "cycles the checklist to the end when input is l" do
      mock_input("l")

      stub_request(:put, /checklist/).to_return(body: api_checklist.to_json)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      described_class.handle_input(make_state(cards: [make_card_with_item]))

      expect(a_request(:put, /checklist/)).to have_been_made.once
    end

    it "cycles the card to the end when input is c" do
      mock_input("c")

      stub_request(:put, /cards/).to_return(body: api_card.to_json)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      described_class.handle_input(make_state(cards: [make_card_with_item]))

      expect(a_request(:put, /cards/)).to have_been_made.once
    end

    it "returns the state unchanged when input is not recognized" do
      state = make_state
      mock_input("x")

      expect(described_class.handle_input(state)).to eq(state)
    end
  end
end
