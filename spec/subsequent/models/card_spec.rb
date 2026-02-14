# frozen_string_literal: true

RSpec.describe Subsequent::Models::Card do
  before { Subsequent::Models::Tag.clear }

  describe "#==" do
    it "returns true for same id" do
      card1 = make_card(id: 1)
      card2 = make_card(id: 1)

      expect(card1).to eq(card2)
    end

    it "returns false for different id" do
      card1 = make_card(id: 1)
      card2 = make_card(id: 2)

      expect(card1).not_to eq(card2)
    end
  end

  describe "#tags" do
    it "returns unique tags from checklists with unchecked items" do
      card = make_card
      checklist = make_checklist(card:, name: "@tag stuff")
      checklist.items << make_checklist_item
      card.checklists << checklist

      expect(card.tags.map(&:name)).to eq(["@tag"])
    end

    it "excludes tags from fully-checked checklists" do
      card = make_card_with_item.tap { _1.checklists.first.name = "@todo" }
      done = make_checklist(card:, id: "c1", name: "@done")
      done.items << make_checklist_item(state: "complete")
      card.checklists << done

      expect(card.tags.map(&:name)).to eq(["@todo"])
    end
  end
end
