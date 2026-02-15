# frozen_string_literal: true

RSpec.describe Subsequent::Options::CycleChecklistItem do
  describe ".match?" do
    it "returns true when text is i" do
      expect(described_class.match?(make_state, "i")).to be(true)
    end

    it "returns false when text is not i" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "updates the checklist item position via API" do
      stub_request(:put, /checkItem/).to_return(body: api_item.to_json)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      described_class.call(make_state(cards: [make_card_with_item]), "i")

      expect(a_request(:put, /checkItem/)).to have_been_made.once
    end
  end
end
