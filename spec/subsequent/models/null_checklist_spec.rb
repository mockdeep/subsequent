# frozen_string_literal: true

RSpec.describe Subsequent::Models::NullChecklist do
  describe "#unchecked_items" do
    it "returns an empty array" do
      expect(described_class.new.unchecked_items).to eq([])
    end
  end

  describe "#present?" do
    it "returns false" do
      expect(described_class.new.present?).to be(false)
    end
  end
end
