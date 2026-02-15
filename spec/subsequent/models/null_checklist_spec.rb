# frozen_string_literal: true

RSpec.describe Subsequent::Models::NullChecklist do
  describe "#name" do
    it 'returns "<no checklist>"' do
      expect(described_class.new.name).to eq("<no checklist>")
    end
  end

  describe "#==" do
    it "returns true for another NullChecklist" do
      expect(described_class.new == described_class.new).to be(true)
    end

    it "returns false for other objects" do
      expect(described_class.new == "something").to be(false)
    end
  end

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
