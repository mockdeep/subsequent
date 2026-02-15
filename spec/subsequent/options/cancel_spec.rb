# frozen_string_literal: true

RSpec.describe Subsequent::Options::Cancel do
  describe ".match?" do
    it "returns true when text is empty string" do
      expect(described_class.match?(make_state, "")).to be(true)
    end

    it "returns true when text is q" do
      expect(described_class.match?(make_state, "q")).to be(true)
    end

    it "returns true when text is Ctrl+D" do
      expect(described_class.match?(make_state, "\u0004")).to be(true)
    end

    it "returns true when text is Ctrl+C" do
      expect(described_class.match?(make_state, "\u0003")).to be(true)
    end

    it "returns false when text is something else" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "returns state with Normal mode" do
      state = make_state

      expect(described_class.call(state, "q"))
        .to eq(state.with(mode: Subsequent::Modes::Normal))
    end
  end
end
