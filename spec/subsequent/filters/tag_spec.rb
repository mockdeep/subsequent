# frozen_string_literal: true

RSpec.describe Subsequent::Filters::Tag do
  def card_with_checklist(name:)
    make_card(checklists: [api_checklist(name:, check_items: [api_item])])
  end

  def card_with_two_checklists
    make_card(
      checklists: [
        api_checklist(id: "1", name: "@tag stuff", check_items: [api_item]),
        api_checklist(id: "2", name: "other", check_items: [api_item]),
      ],
    )
  end

  describe "#call" do
    it "returns cards with checklists that have the tag" do
      card = card_with_checklist(name: "@tag stuff")

      expect(described_class.new("@tag").call([card])).to eq([card])
    end

    it "narrows card checklists to only matching ones" do
      card = card_with_two_checklists

      result = described_class.new("@tag").call([card])

      expect(result.first.checklists).to eq([card.checklists.first])
    end

    it "does not mutate the original card" do
      card = card_with_two_checklists
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
