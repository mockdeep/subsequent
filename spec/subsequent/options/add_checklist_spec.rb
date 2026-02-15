# frozen_string_literal: true

RSpec.describe Subsequent::Options::AddChecklist do
  describe ".match?" do
    it "returns true when text is l" do
      expect(described_class.match?(make_state, "l")).to be(true)
    end

    it "returns false when text is not l" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "returns state with AddChecklist mode" do
      state = make_state

      expect(described_class.call(state, "l"))
        .to eq(state.with(mode: Subsequent::Modes::AddChecklist))
    end
  end
end
