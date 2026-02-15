# frozen_string_literal: true

RSpec.describe Subsequent::Options::FilterMode do
  describe ".match?" do
    it "returns true when text is f" do
      expect(described_class.match?(make_state, "f")).to be(true)
    end

    it "returns false when text is not f" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "returns state with Filter mode" do
      state = make_state

      expect(described_class.call(state, "f"))
        .to eq(state.with(mode: Subsequent::Modes::Filter))
    end
  end
end
