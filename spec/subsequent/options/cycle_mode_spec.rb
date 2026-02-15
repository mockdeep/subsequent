# frozen_string_literal: true

RSpec.describe Subsequent::Options::CycleMode do
  describe ".match?" do
    it "returns true when text is c" do
      expect(described_class.match?(make_state, "c")).to be(true)
    end

    it "returns false when text is not c" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "returns state with Cycle mode" do
      state = make_state

      expect(described_class.call(state, "c"))
        .to eq(state.with(mode: Subsequent::Modes::Cycle))
    end
  end
end
