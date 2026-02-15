# frozen_string_literal: true

RSpec.describe Subsequent::Options::Refresh do
  describe ".match?" do
    it "returns true when text is r" do
      expect(described_class.match?(make_state, "r")).to be(true)
    end

    it "returns false when text is not r" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "fetches data from the API" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      described_class.call(make_state, "r")

      expect(a_request(:get, /cards/)).to have_been_made.once
    end
  end
end
