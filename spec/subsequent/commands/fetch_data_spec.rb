# frozen_string_literal: true

RSpec.describe Subsequent::Commands::FetchData do
  describe ".initial" do
    it "fetches cards from Trello API" do
      get_url = api_url("lists/test-list-id/cards", checklists: "all")
      stub_request(:get, get_url).to_return(body: [api_card].to_json)

      described_class.initial(
        filter: Subsequent::Filters::None,
        sort: Subsequent::Sorts::First,
        list_id: "test-list-id",
      )

      expect(a_request(:get, get_url)).to have_been_made.once
    end

    it "preserves filter when filter is not a Tag filter" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      filter = Subsequent::Filters::None

      result = described_class.initial(
        filter:,
        sort: Subsequent::Sorts::First,
        list_id: "test-list-id",
      )

      expect(result.filter).to eq(Subsequent::Filters::None)
    end

    it "preserves tag filter through re-fetch" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      filter = Subsequent::Filters::Tag.new("@tag")

      result = described_class.initial(
        filter:,
        sort: Subsequent::Sorts::First,
        list_id: "test-list-id",
      )

      expect(result.filter).to eq(Subsequent::Filters::Tag.new("@tag"))
    end

    it "returns a new State with the fetched cards" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      result = described_class.initial(
        filter: Subsequent::Filters::None,
        sort: Subsequent::Sorts::First,
        list_id: "test-list-id",
      )

      expect(result).to be_a(Subsequent::State)
      expect(result.cards.size).to eq(1)
      expect(result.cards.first.name).to eq("blah")
    end

    it "fetches from the given list" do
      url = api_url("lists/other-list/cards", checklists: "all")
      stub_request(:get, url).to_return(body: [api_card].to_json)

      result = described_class.initial(
        filter: Subsequent::Filters::None,
        sort: Subsequent::Sorts::First,
        list_id: "other-list",
      )

      expect(a_request(:get, url)).to have_been_made.once
      expect(result.list_id).to eq("other-list")
    end

    it "passes extra state args through" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      lists = [make_list]

      result = described_class.initial(
        filter: Subsequent::Filters::None,
        sort: Subsequent::Sorts::First,
        list_id: "test-list-id",
        lists:,
      )

      expect(result.lists).to eq(lists)
    end
  end

  describe ".call" do
    it "re-fetches the list the state is on" do
      url = api_url("lists/other-list/cards", checklists: "all")
      stub_request(:get, url).to_return(body: [api_card].to_json)
      state = make_state(list_id: "other-list")

      result = described_class.call(state)

      expect(a_request(:get, url)).to have_been_made.once
      expect(result.list_id).to eq("other-list")
    end

    it "keeps the sort, filter, and cached lists from the state" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      lists = [make_list]
      state = make_state(
        filter: Subsequent::Filters::Tag.new("@tag"),
        sort: Subsequent::Sorts::MostUncheckedItems,
        lists:,
      )

      result = described_class.call(state)

      expect(result.filter).to eq(Subsequent::Filters::Tag.new("@tag"))
      expect(result.sort).to eq(Subsequent::Sorts::MostUncheckedItems)
      expect(result.lists).to eq(lists)
    end

    it "lets state args override what the state carries over" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      state = make_state(filter: Subsequent::Filters::Tag.new("@tag"))

      result = described_class.call(state, filter: Subsequent::Filters::None)

      expect(result.filter).to eq(Subsequent::Filters::None)
    end
  end
end
