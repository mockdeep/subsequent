# frozen_string_literal: true

RSpec.describe Subsequent::Options::BrowseCard do
  describe ".match?" do
    it "returns true when text is c" do
      expect(described_class.match?(make_state, "c")).to be(true)
    end

    it "returns false when text is not c" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "enters SelectCard mode" do
      result = described_class.call(make_state, "c")

      expect(result.mode).to eq(Subsequent::Modes::SelectCard)
    end

    it "resets browse_page to 0" do
      state = make_state(browse_page: 2)

      expect(described_class.call(state, "c").browse_page).to eq(0)
    end
  end
end
