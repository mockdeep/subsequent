# frozen_string_literal: true

RSpec.describe Subsequent::Options::Sort do
  describe ".match?" do
    it "returns true when text is f" do
      expect(described_class.match?(make_state, "f")).to be(true)
    end

    it "returns true when text is l" do
      expect(described_class.match?(make_state, "l")).to be(true)
    end

    it "returns true when text is m" do
      expect(described_class.match?(make_state, "m")).to be(true)
    end

    it "returns false when text is something else" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "returns state with First sort when text is f" do
      result = described_class.call(make_state, "f")

      expect(result.sort).to eq(Subsequent::Sorts::First)
    end

    it "returns state with LeastUncheckedItems sort when text is l" do
      result = described_class.call(make_state, "l")

      expect(result.sort).to eq(Subsequent::Sorts::LeastUncheckedItems)
    end

    it "returns state with MostUncheckedItems sort when text is m" do
      result = described_class.call(make_state, "m")

      expect(result.sort).to eq(Subsequent::Sorts::MostUncheckedItems)
    end
  end
end
