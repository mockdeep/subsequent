# frozen_string_literal: true

RSpec.describe Subsequent::State do
  before { Subsequent::Models::Tag.clear }

  describe "default mode" do
    it "is Modes::Normal" do
      state = make_state

      expect(state.mode).to eq(Subsequent::Modes::Normal)
    end
  end

  describe "filter" do
    it "applies filter to cards" do
      card1 = make_card(id: 1)
      card2 = make_card(id: 2)
      filter = ->(cards) { cards.select { |c| c.id == 2 } }

      state = make_state(cards: [card1, card2], filter:)

      expect(state.cards).to eq([card2])
    end
  end

  describe "sort" do
    it "applies sort to select card" do
      card1 = make_card_with_item
      card2 = make_card_with_item
      sort = :last.to_proc

      state = make_state(cards: [card1, card2], sort:)

      expect(state.card).to eq(card2)
    end
  end

  describe "fallbacks" do
    it "falls back to NullCard when no cards match" do
      state = make_state(cards: [])

      expect(state.card).to be_a(Subsequent::Models::NullCard)
    end

    it "falls back to NullChecklist when card has no unchecked checklists" do
      state = make_state(cards: [make_card(checklists: [])])

      expect(state.checklist).to be_a(Subsequent::Models::NullChecklist)
    end
  end

  describe "checklist_items" do
    it "limits to first 5 unchecked items" do
      card = make_card
      checklist = make_checklist(card:)
      6.times { |i| checklist.items << make_checklist_item(id: i, pos: i) }
      card.checklists << checklist

      expect(make_state(cards: [card]).checklist_items.size).to eq(5)
    end
  end

  describe "#tags" do
    it "returns unique sorted tags across all cards" do
      card1 = make_card_with_item.tap { _1.checklists.first.name = "@beta" }
      card2 = make_card_with_item.tap { _1.checklists.first.name = "@alpha" }

      expect(make_state(cards: [card1, card2]).tags.map(&:name))
        .to eq(["@alpha", "@beta"])
    end
  end

  describe "#title" do
    it "formats as 'card name - checklist name (link)'" do
      state = make_state(cards: [make_card_with_item])

      expect(state.title)
        .to eq("Card Name - Checklist (\e]8;;http://example.com\e\\link\e]8;;\e\\)")
    end
  end

  describe "#checklist_string" do
    it "formats numbered items with their to_s output" do
      state = make_state(cards: [make_card_with_item])
      item = state.checklist_items.first

      expect(state.checklist_string).to eq("1. #{item}")
    end

    it "shows empty message when no items" do
      state = make_state(cards: [])

      expect(state.checklist_string)
        .to eq("No unchecked items, finish the card!")
    end
  end

  describe "#tag_string" do
    it "formats indexed tags with cyan numbering and tag name" do
      card = make_card_with_item
      card.checklists.first.name = "@tag stuff"
      state = make_state(cards: [card])

      expect(state.tag_string).to eq("(\e[36m1\e[0m) @tag (1)")
    end
  end
end
