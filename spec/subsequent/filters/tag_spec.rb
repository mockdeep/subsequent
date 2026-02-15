# frozen_string_literal: true

RSpec.describe Subsequent::Filters::Tag do
  def card_with_checklist(name:)
    card = make_card
    checklist = make_checklist(card:, name:)
    checklist.items << make_checklist_item
    card.checklists << checklist
    card
  end

  describe "#call" do
    it "returns cards with checklists that have the tag" do
      card = card_with_checklist(name: "@tag stuff")

      expect(described_class.new("@tag").call([card])).to eq([card])
    end

    it "narrows card checklists to only matching ones" do
      card = card_with_checklist(name: "@tag stuff")
      matching = card.checklists.first
      card.checklists << card_with_checklist(name: "other").checklists.first

      result = described_class.new("@tag").call([card])

      expect(result.first.checklists).to eq([matching])
    end

    it "does not mutate the original card" do
      card = card_with_checklist(name: "@tag stuff")
      card.checklists << card_with_checklist(name: "other").checklists.first
      original_checklists = card.checklists.dup

      described_class.new("@tag").call([card])

      expect(card.checklists).to eq(original_checklists)
    end

    it "excludes cards with no matching checklists" do
      card = card_with_checklist(name: "no tag here")

      expect(described_class.new("@tag").call([card])).to be_empty
    end
  end

  describe "#==" do
    it "returns true if the tag names are the same" do
      tag1 = described_class.new("@tag1")
      tag2 = described_class.new("@tag1")

      expect(tag1).to eq(tag2)
    end

    it "returns false if the tag names are different" do
      tag1 = described_class.new("@tag1")
      tag2 = described_class.new("@tag2")

      expect(tag1).not_to eq(tag2)
    end

    it "returns false if the other object does not respond to :tag_name" do
      tag = described_class.new("@tag1")
      other = Object.new

      expect(tag).not_to eq(other)
    end
  end
end
