# frozen_string_literal: true

RSpec.describe Subsequent::Models::NullCard do
  describe "#checklists" do
    it "returns an empty array" do
      expect(described_class.new.checklists).to eq([])
    end
  end

  describe "#name" do
    it "returns a null card name" do
      expect(described_class.new.name).to eq("<No card>")
    end
  end

  describe "#short_url" do
    it "returns nil" do
      expect(described_class.new.short_url).to be_nil
    end
  end
end
