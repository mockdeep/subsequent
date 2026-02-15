# frozen_string_literal: true

RSpec.describe Subsequent::State do
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
      items = 6.times.map { |i| api_item(id: i, pos: i) }
      card = make_card(checklists: [api_checklist(check_items: items)])

      expect(make_state(cards: [card]).checklist_items.size).to eq(5)
    end
  end

  describe "#tags" do
    it "returns unique sorted tags across all cards" do
      card1 = make_card(id: 1, checklists: [tagged_checklist("@beta")])
      card2 = make_card(id: 2, checklists: [tagged_checklist("@alpha")])

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
      card = make_card(checklists: [tagged_checklist("@tag stuff")])
      state = make_state(cards: [card])

      expect(state.tag_string).to eq("(\e[36m1\e[0m) @tag (1)")
    end

    it "paginates tags in slices of 9" do
      state = state_with_tags(10, tag_page: 1)

      expect(state.tag_string).to include("(\e[36m1\e[0m) @tag9")
    end

    it "returns empty string for an out-of-range page" do
      state = make_state(tag_page: 5)

      expect(state.tag_string).to eq("")
    end
  end

  describe "#tag_page" do
    it "defaults to 0" do
      expect(make_state.tag_page).to eq(0)
    end
  end

  def tagged_checklist(name)
    api_checklist(name:, check_items: [api_item])
  end

  def state_with_tags(count, tag_page: 0)
    cards =
      count.times.map do |i|
        make_card(id: i, checklists: [tagged_checklist("@tag#{i}")])
      end
    make_state(cards:, tag_page:)
  end
end
