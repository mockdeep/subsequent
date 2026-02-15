# frozen_string_literal: true

RSpec.describe Subsequent::Commands::ToggleChecklistItem do
  describe ".call" do
    it "toggles the correct checklist item via API" do
      state = make_state(cards: [make_card_with_item])
      stub_request(:put, /checkItem/).to_return(body: "{}")

      described_class.call(state, "1")

      expect(a_request(:put, /checkItem/)).to have_been_made.once
    end

    it "indexes into checklist_items using 1-based char" do
      card = make_card
      checklist = make_checklist
      item1 = make_checklist_item(id: 10, name: "First")
      item2 = make_checklist_item(id: 20, name: "Second", pos: 2)
      card.checklists << checklist
      checklist.items.push(item1, item2)
      state = make_state(cards: [card])

      put_url = api_url(
        "cards/#{item2.card_id}/checkItem/#{item2.id}",
        state: "complete",
      )
      stub_request(:put, put_url).to_return(body: "{}")

      described_class.call(state, "2")

      expect(a_request(:put, put_url)).to have_been_made.once
    end

    it "returns the original state" do
      state = make_state(cards: [make_card_with_item])
      stub_request(:put, /checkItem/).to_return(body: "{}")

      result = described_class.call(state, "1")

      expect(result).to eq(state)
    end
  end
end
