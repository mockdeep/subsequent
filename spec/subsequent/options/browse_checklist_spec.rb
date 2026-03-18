# frozen_string_literal: true

RSpec.describe Subsequent::Options::BrowseChecklist do
  describe ".match?" do
    it "returns true when text is k" do
      expect(described_class.match?(make_state, "k")).to be(true)
    end

    it "returns false when text is not k" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "enters SelectChecklist mode" do
      result = described_class.call(make_state, "k")

      expect(result.mode).to eq(Subsequent::Modes::SelectChecklist)
    end

    it "resets browse_page to 0" do
      state = make_state(browse_page: 2)

      expect(described_class.call(state, "k").browse_page).to eq(0)
    end
  end
end
