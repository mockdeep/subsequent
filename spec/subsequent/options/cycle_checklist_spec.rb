# frozen_string_literal: true

RSpec.describe Subsequent::Options::CycleChecklist do
  describe ".match?" do
    it "returns true when text is l" do
      expect(described_class.match?(make_state, "l")).to be(true)
    end

    it "returns false when text is not l" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "updates the checklist position via API" do
      stub_request(:put, /checklist/).to_return(body: api_checklist.to_json)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      described_class.call(make_state(cards: [make_card_with_item]), "l")

      expect(a_request(:put, /checklist/)).to have_been_made.once
    end
  end
end
