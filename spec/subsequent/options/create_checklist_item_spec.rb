# frozen_string_literal: true

RSpec.describe Subsequent::Options::CreateChecklistItem do
  describe ".match?" do
    it "always returns true" do
      expect(described_class.match?(make_state, "anything")).to be(true)
    end
  end

  describe ".call" do
    it "returns state with AddChecklistItem mode" do
      state = make_state(cards: [make_card_with_item])
      stub_request(:post, /checkItems/).to_return(body: api_item.to_json)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      expect(described_class.call(state, "New Item").mode)
        .to eq(Subsequent::Modes::AddChecklistItem)
    end
  end
end
