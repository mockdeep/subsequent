# frozen_string_literal: true

RSpec.describe Subsequent::Filters::Tag do
  describe "#call" do
    it "returns cards with checklists that have the tag" do
      tag = "@tag1"
      checklist1 = api_checklist(name: tag, check_items: [api_item])
      card = make_card(checklists: [checklist1])

      result = described_class.new(tag).call([card])

      expect(result).to eq([card])
    end
  end

  describe "#==" do
    it "returns true if the tags are the same" do
      tag1 = described_class.new("tag1")
      tag2 = described_class.new("tag1")

      expect(tag1).to eq(tag2)
    end

    it "returns false if the tags are different" do
      tag1 = described_class.new("tag1")
      tag2 = described_class.new("tag2")

      expect(tag1).not_to eq(tag2)
    end

    it "returns false if the other object does not respond to :tag" do
      tag = described_class.new("tag1")
      other = Object.new

      expect(tag).not_to eq(other)
    end
  end
end
