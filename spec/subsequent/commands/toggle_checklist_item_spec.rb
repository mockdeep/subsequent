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
      card = make_card(
        checklists: [
          api_checklist(
            check_items: [
              api_item(id: 10, name: "First"),
              api_item(id: 20, name: "Second", pos: 2),
            ],
          ),
        ],
      )
      state = make_state(cards: [card])
      item2 = state.checklist_items.fetch(1)

      put_url = api_url(
        "cards/#{item2.card_id}/checkItem/#{item2.id}",
        state: "complete",
      )
      stub_request(:put, put_url).to_return(body: "{}")

      described_class.call(state, "2")

      expect(a_request(:put, put_url)).to have_been_made.once
    end

    it "toggles the item to complete when it is incomplete" do
      state = make_state(cards: [make_card_with_item])
      stub_request(:put, /checkItem/).to_return(body: "{}")

      result = described_class.call(state, "1")

      expect(result.checklist_items.first.checked?).to be(true)
    end

    it "toggles the item to incomplete when it is complete" do
      card = make_card(
        checklists: [
          api_checklist(
            check_items: [
              api_item(id: 1, name: "First"),
              api_item(id: 2, name: "Second", pos: 2, state: "complete"),
            ],
          ),
        ],
      )
      complete_item = card.checklists.first.items.last
      state = make_state(cards: [card], checklist_items: [complete_item])
      stub_request(:put, /checkItem/).to_return(body: "{}")

      result = described_class.call(state, "1")

      expect(result.checklist_items.first.checked?).to be(false)
    end

    it "returns a new state" do
      state = make_state(cards: [make_card_with_item])
      stub_request(:put, /checkItem/).to_return(body: "{}")

      result = described_class.call(state, "1")

      expect(result).not_to eq(state)
    end

    it "does not mutate the original checklist item" do
      state = make_state(cards: [make_card_with_item])
      stub_request(:put, /checkItem/).to_return(body: "{}")

      described_class.call(state, "1")

      expect(state.checklist_items.first.checked?).to be(false)
    end

    it "renders loading state before the API call" do
      state = make_state(cards: [make_card_with_item])
      rendered_output = nil

      allow(Subsequent::TrelloClient).to receive(:toggle_checklist_item) do
        rendered_output = output.string.dup
      end

      described_class.call(state, "1")

      expect(rendered_output).to include("○")
    end

    it "sets the terminal title during loading" do
      state = make_state(cards: [make_card_with_item])
      rendered_output = nil

      allow(Subsequent::TrelloClient).to receive(:toggle_checklist_item) do
        rendered_output = output.string.dup
      end

      described_class.call(state, "1")

      expect(rendered_output).to include("\e]0;Card Name\a")
    end
  end
end
