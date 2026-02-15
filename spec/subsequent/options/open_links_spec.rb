# frozen_string_literal: true

RSpec.describe Subsequent::Options::OpenLinks do
  describe ".match?" do
    it "returns true when text is o" do
      expect(described_class.match?(make_state, "o")).to be(true)
    end

    it "returns false when text is not o" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "delegates to OpenLinks command" do
      state = make_state
      allow(Subsequent::Commands::OpenLinks).to receive(:system)

      result = described_class.call(state, "o")

      expect(result).to eq(state)
    end
  end
end
