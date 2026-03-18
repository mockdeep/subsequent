# frozen_string_literal: true

RSpec.describe Subsequent::Options::BrowseMode do
  describe ".match?" do
    it "returns true when text is b" do
      expect(described_class.match?(make_state, "b")).to be(true)
    end

    it "returns false when text is not b" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "enters Browse mode" do
      result = described_class.call(make_state, "b")

      expect(result.mode).to eq(Subsequent::Modes::Browse)
    end
  end
end
