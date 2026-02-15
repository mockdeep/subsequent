# frozen_string_literal: true

RSpec.describe Subsequent::Options::SortMode do
  describe ".match?" do
    it "returns true when text is s" do
      expect(described_class.match?(make_state, "s")).to be(true)
    end

    it "returns false when text is not s" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "returns state with Sort mode" do
      state = make_state

      expect(described_class.call(state, "s"))
        .to eq(state.with(mode: Subsequent::Modes::Sort))
    end
  end
end
