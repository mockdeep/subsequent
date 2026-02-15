# frozen_string_literal: true

RSpec.describe Subsequent::Options::CreateCard do
  describe ".match?" do
    it "always returns true" do
      expect(described_class.match?(make_state, "anything")).to be(true)
    end
  end

  describe ".call" do
    it "returns state with AddChecklist mode" do
      stub_request(:post, /cards/).to_return(body: api_card.to_json)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      result = described_class.call(make_state, "New Card")

      expect(result.mode).to eq(Subsequent::Modes::AddChecklist)
    end
  end
end
