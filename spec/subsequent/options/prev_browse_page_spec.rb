# frozen_string_literal: true

RSpec.describe Subsequent::Options::PrevBrowsePage do
  describe ".match?" do
    it "returns true when not on the first page" do
      state = make_state(browse_page: 1)

      expect(described_class.match?(state, "<")).to be(true)
    end

    it "returns false when on the first page" do
      state = make_state(browse_page: 0)

      expect(described_class.match?(state, "<")).to be(false)
    end

    it "returns false when text is not <" do
      state = make_state(browse_page: 1)

      expect(described_class.match?(state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "decrements the browse page" do
      state = make_state(browse_page: 1)

      expect(described_class.call(state, "<").browse_page).to eq(0)
    end
  end
end
