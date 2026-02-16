# frozen_string_literal: true

RSpec.describe Subsequent::Options::CancelBrowse do
  describe ".match?" do
    it "returns true when text is q" do
      expect(described_class.match?(make_state, "q")).to be(true)
    end

    it "returns true when text is empty string" do
      expect(described_class.match?(make_state, "")).to be(true)
    end

    it "returns false when text is something else" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "returns state with SelectList mode" do
      result = described_class.call(make_state, "q")

      expect(result.mode).to eq(Subsequent::Modes::SelectList)
    end

    it "resets browse_page to 0" do
      state = make_state(browse_page: 1)

      result = described_class.call(state, "q")

      expect(result.browse_page).to eq(0)
    end
  end
end
