# frozen_string_literal: true

RSpec.describe Subsequent::Options::ArchiveCard do
  describe ".match?" do
    it "returns true when text is a" do
      expect(described_class.match?(make_state, "a")).to be(true)
    end

    it "returns false when text is not a" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "archives the card via API" do
      mock_input("y")
      stub_request(:put, /cards/).to_return(body: api_card.to_json)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      described_class.call(make_state, "a")

      expect(a_request(:put, /cards/)).to have_been_made.once
    end
  end
end
