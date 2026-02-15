# frozen_string_literal: true

RSpec.describe Subsequent::Options::AddItemMode do
  describe ".match?" do
    it "returns true when text is n" do
      expect(described_class.match?(make_state, "n")).to be(true)
    end

    it "returns false when text is not n" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "returns state with AddItem mode" do
      state = make_state

      expect(described_class.call(state, "n"))
        .to eq(state.with(mode: Subsequent::Modes::AddItem))
    end
  end
end
