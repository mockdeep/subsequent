# frozen_string_literal: true

RSpec.describe Subsequent::Options::Refresh do
  describe ".match?" do
    it "returns true when text is r" do
      expect(described_class.match?(make_state, "r")).to be(true)
    end

    it "returns false when text is not r" do
      expect(described_class.match?(make_state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "fetches data from the API" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      described_class.call(make_state, "r")

      expect(a_request(:get, /cards/)).to have_been_made.once
    end

    it "preserves the selected card after refresh" do
      target_card = api_card.merge(id: "target", name: "Target")
      other_card = api_card.merge(id: "other", name: "Other")
      stub_request(:get, /cards/)
        .to_return(body: [other_card, target_card].to_json)

      state = make_state(
        cards: [make_card(id: "target"), make_card(id: "other")],
        card: make_card(id: "target"),
      )

      result = described_class.call(state, "r")

      expect(result.card.id).to eq("target")
    end

    it "selects first unchecked checklist after refresh" do
      checklist1_data = api_checklist(
        id: "cl-first",
        check_items: [api_item(id: 1)],
      )
      checklist2_data = api_checklist(
        id: "cl-second",
        pos: 2,
        check_items: [api_item(id: 2)],
      )
      card_data = api_card.merge(
        id: "target",
        checklists: [checklist1_data, checklist2_data],
      )
      stub_request(:get, /cards/).to_return(body: [card_data].to_json)

      card = make_card(
        id: "target",
        checklists: [checklist1_data, checklist2_data],
      )

      state = make_state(
        cards: [card],
        card:,
        checklist: card.checklists.last,
        checklist_items: card.checklists.last.unchecked_items.first(5),
      )

      result = described_class.call(state, "r")

      expect(result.checklist.id).to eq("cl-first")
    end

    it "preserves browsed checklist after refresh" do
      checklist1_data = api_checklist(
        id: "cl-first",
        check_items: [api_item(id: 1)],
      )
      checklist2_data = api_checklist(
        id: "cl-browsed",
        pos: 2,
        check_items: [api_item(id: 2)],
      )
      card_data = api_card.merge(
        id: "target",
        checklists: [checklist1_data, checklist2_data],
      )
      stub_request(:get, /cards/).to_return(body: [card_data].to_json)

      card = make_card(
        id: "target",
        checklists: [checklist1_data, checklist2_data],
      )

      state = make_state(
        cards: [card],
        card:,
        checklist: card.checklists.last,
        checklist_items: card.checklists.last.unchecked_items.first(5),
      ).with(browsed_checklist: true)

      result = described_class.call(state, "r")

      expect(result.checklist.id).to eq("cl-browsed")
    end

    it "advances browsed checklist when it has no unchecked items" do
      checklist1_data = api_checklist(
        id: "cl-done",
        check_items: [api_item(state: "complete")],
      )
      checklist2_data = api_checklist(
        id: "cl-next",
        pos: 2,
        check_items: [api_item(id: 2)],
      )
      card_data = api_card.merge(
        id: "target",
        checklists: [checklist1_data, checklist2_data],
      )
      stub_request(:get, /cards/).to_return(body: [card_data].to_json)

      card = make_card(
        id: "target",
        checklists: [checklist1_data, checklist2_data],
      )

      state = make_state(
        cards: [card],
        card:,
        checklist: card.checklists.first,
        checklist_items: [],
      ).with(browsed_checklist: true)

      result = described_class.call(state, "r")

      expect(result.checklist.id).to eq("cl-next")
    end

    it "falls back when browsed checklist no longer exists" do
      checklist_data = api_checklist(
        id: "cl-remaining",
        check_items: [api_item],
      )
      card_data = api_card.merge(id: "target", checklists: [checklist_data])
      stub_request(:get, /cards/).to_return(body: [card_data].to_json)

      card = make_card(id: "target", checklists: [checklist_data])

      state = make_state(
        cards: [card],
        card:,
        checklist: make_checklist(id: "cl-gone"),
      ).with(browsed_checklist: true)

      result = described_class.call(state, "r")

      expect(result.checklist.id).to eq("cl-remaining")
    end

    it "advances when selected checklist has no unchecked items" do
      checklist1_data = api_checklist(
        id: "cl-done",
        check_items: [api_item(state: "complete")],
      )
      checklist2_data = api_checklist(
        id: "cl-next",
        pos: 2,
        check_items: [api_item(id: 2, name: "Next Item")],
      )
      card_data = api_card.merge(
        id: "target",
        checklists: [checklist1_data, checklist2_data],
      )
      stub_request(:get, /cards/).to_return(body: [card_data].to_json)

      card = make_card(
        id: "target",
        checklists: [checklist1_data, checklist2_data],
      )

      state = make_state(
        cards: [card],
        card:,
        checklist: card.checklists.first,
        checklist_items: [],
      )

      result = described_class.call(state, "r")

      expect(result.checklist.id).to eq("cl-next")
    end

    it "falls back to default when card no longer exists" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      state = make_state(
        cards: [make_card(id: "gone")],
        card: make_card(id: "gone"),
      )

      result = described_class.call(state, "r")

      expect(result.card.id).to eq("123")
    end

    it "falls back to default when no cards matched" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      state = make_state(cards: [])

      result = described_class.call(state, "r")

      expect(result.card.id).to eq("123")
    end
  end
end
