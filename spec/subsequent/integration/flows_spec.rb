# frozen_string_literal: true

RSpec.describe "integration flows" do
  def initial_state(cards)
    url = api_url("lists/test-list-id/cards", checklists: "all")
    stub_request(:get, url).to_return(body: cards.to_json)

    Subsequent::Actions::Run.__send__(:initial_state)
  end

  def tick(state, chars)
    Subsequent::Configuration.input = StringIO.new(chars)
    Subsequent::Actions::Run.__send__(:tick, state)
  end

  def stub_browse_cards(list_id, cards)
    url = api_url("lists/#{list_id}/cards", checklists: "all")
    stub_request(:get, url).to_return(body: cards.to_json)
  end

  def stub_lists(lists)
    url = api_url("boards/test-board-id/lists", filter: "open")
    stub_request(:get, url).to_return(body: lists.to_json)
  end

  let(:item_a) do
    { id: "10", name: "Item A", pos: 1, state: "incomplete" }
  end

  let(:item_b) do
    { id: "11", name: "Item B", pos: 2, state: "incomplete" }
  end

  let(:checklist_one) do
    api_checklist(
      id: "cl-1",
      name: "Checklist @dev",
      pos: 1,
      check_items: [item_a, item_b],
    )
  end

  let(:checklist_two) do
    api_checklist(
      id: "cl-2",
      name: "Checklist @design",
      pos: 2,
      check_items: [
        {
          id: "20",
          name: "Design Item",
          pos: 1,
          state: "incomplete",
        },
      ],
    )
  end

  let(:card_one) do
    {
      id: "card-1",
      name: "First Card",
      pos: 1,
      short_url: "http://example.com/1",
      checklists: [checklist_one, checklist_two],
    }
  end

  let(:card_two) do
    {
      id: "card-2",
      name: "Second Card",
      pos: 2,
      short_url: "http://example.com/2",
      checklists: [
        api_checklist(
          id: "cl-3",
          name: "Tasks",
          pos: 1,
          check_items: [
            {
              id: "30",
              name: "Task One",
              pos: 1,
              state: "incomplete",
            },
          ],
        ),
      ],
    }
  end

  describe "browse flow" do
    it "navigates through lists, cards, and checklists" do
      lists = [
        { id: "list-a", name: "Backlog" },
        { id: "list-b", name: "In Progress" },
      ]
      stub_lists(lists)
      stub_browse_cards("list-b", [card_one, card_two])

      state = initial_state([card_one, card_two])
      expect(state.mode).to eq(Subsequent::Modes::Normal)

      state = tick(state, "b")
      expect(state.mode).to eq(Subsequent::Modes::SelectList)
      expect(state.lists.map(&:name)).to eq(["Backlog", "In Progress"])

      state = tick(state, "2")
      expect(state.mode).to eq(Subsequent::Modes::SelectCard)
      expect(state.browse_list_id).to eq("list-b")

      state = tick(state, "1")
      expect(state.mode).to eq(Subsequent::Modes::SelectChecklist)
      expect(state.card.name).to eq("First Card")

      state = tick(state, "2")
      expect(state.mode).to eq(Subsequent::Modes::Normal)
      expect(state.checklist.name).to eq("Checklist @design")
      expect(state.checklist_items.map(&:name)).to eq(["Design Item"])
    end
  end

  describe "sort then toggle flow" do
    it "sorts and toggles an item" do
      toggle_url = api_url("cards/card-1/checkItem/10", state: "complete")
      stub_request(:put, toggle_url).to_return(body: "{}")

      state = initial_state([card_one, card_two])

      state = tick(state, "s")
      expect(state.mode).to eq(Subsequent::Modes::Sort)

      state = tick(state, "m")
      expect(state.mode).to eq(Subsequent::Modes::Normal)
      expect(state.sort).to eq(Subsequent::Sorts::MostUncheckedItems)
      expect(state.card.name).to eq("First Card")

      tick(state, "1")

      expect(a_request(:put, toggle_url)).to have_been_made
    end
  end

  describe "filter by tag flow" do
    it "filters cards by tag" do
      state = initial_state([card_one, card_two])
      expect(state.tags.map(&:name)).to eq(["<no tag>", "@design", "@dev"])

      fetch_url = api_url("lists/test-list-id/cards", checklists: "all")
      stub_request(:get, fetch_url)
        .to_return(body: [card_one, card_two].to_json)

      state = tick(state, "f")
      expect(state.mode).to eq(Subsequent::Modes::Filter)

      state = tick(state, "3")
      expect(state.mode).to eq(Subsequent::Modes::Normal)
      expect(state.filter).to eq(Subsequent::Filters::Tag.new("@dev"))
      expect(state.cards.size).to eq(1)
      expect(state.card.name).to eq("First Card")
      expect(state.checklist.name).to eq("Checklist @dev")
    end
  end

  describe "create card flow" do
    it "creates a card, checklist, and item" do
      state = initial_state([card_one])

      card_post = api_url(
        "cards",
        idList: "test-list-id",
        name: "New Card",
        pos: "top",
      )
      checklist_post = api_url(
        "checklists",
        idCard: "card-1",
        name: "New Checklist",
        pos: "top",
      )
      item_post = api_url(
        "checklists/cl-1/checkItems",
        name: "New Item",
        pos: "top",
      )
      stub_request(:post, card_post)
      stub_request(:post, checklist_post)
      stub_request(:post, item_post)

      fetch_url = api_url("lists/test-list-id/cards", checklists: "all")
      stub_request(:get, fetch_url).to_return(body: [card_one].to_json)

      state = tick(state, "n")
      expect(state.mode).to eq(Subsequent::Modes::AddItem)

      state = tick(state, "c")
      expect(state.mode).to eq(Subsequent::Modes::AddCard)

      state = tick(state, "New Card\n")
      expect(state.mode).to eq(Subsequent::Modes::AddChecklist)
      expect(a_request(:post, card_post)).to have_been_made

      state = tick(state, "New Checklist\n")
      expect(state.mode).to eq(Subsequent::Modes::AddChecklistItem)
      expect(a_request(:post, checklist_post)).to have_been_made

      state = tick(state, "New Item\n")
      expect(state.mode).to eq(Subsequent::Modes::AddChecklistItem)
      expect(a_request(:post, item_post)).to have_been_made

      state = tick(state, "q\n")
      expect(state.mode).to eq(Subsequent::Modes::Normal)
    end
  end

  describe "refresh preserves browse state" do
    it "restores card and checklist after refresh" do
      stub_lists([{ id: "list-a", name: "Backlog" }])
      stub_browse_cards("list-a", [card_one, card_two])

      state = initial_state([card_one, card_two])

      state = tick(state, "b")
      state = tick(state, "1")
      state = tick(state, "1")
      state = tick(state, "1")

      expect(state.card.name).to eq("First Card")
      expect(state.checklist.name).to eq("Checklist @dev")
      expect(state.browsed_checklist).to be(true)

      refresh_url = api_url("lists/list-a/cards", checklists: "all")
      stub_request(:get, refresh_url)
        .to_return(body: [card_one, card_two].to_json)

      state = tick(state, "r")

      expect(state.card.name).to eq("First Card")
      expect(state.checklist.name).to eq("Checklist @dev")
      expect(state.checklist_items.map(&:name)).to include("Item A")
    end
  end
end
