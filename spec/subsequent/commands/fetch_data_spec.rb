# frozen_string_literal: true

RSpec.describe Subsequent::Commands::FetchData do
  describe ".call" do
    it "fetches cards from Trello API" do
      get_url = api_url("lists/test-list-id/cards", checklists: "all")
      stub_request(:get, get_url).to_return(body: [api_card].to_json)

      described_class.call(
        filter: Subsequent::Filters::None,
        sort: Subsequent::Sorts::First,
      )

      expect(a_request(:get, get_url)).to have_been_made.once
    end

    it "preserves filter when filter is not a Tag filter" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      filter = Subsequent::Filters::None

      result = described_class.call(filter:, sort: Subsequent::Sorts::First)

      expect(result.filter).to eq(Subsequent::Filters::None)
    end

    it "preserves tag filter through re-fetch" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      filter = Subsequent::Filters::Tag.new("@tag")

      result = described_class.call(filter:, sort: Subsequent::Sorts::First)

      expect(result.filter).to eq(Subsequent::Filters::Tag.new("@tag"))
    end

    it "returns a new State with the fetched cards" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      result = described_class.call(
        filter: Subsequent::Filters::None,
        sort: Subsequent::Sorts::First,
      )

      expect(result).to be_a(Subsequent::State)
      expect(result.cards.size).to eq(1)
      expect(result.cards.first.name).to eq("blah")
    end

    it "fetches from a specific list when list_id is given" do
      url = api_url("lists/other-list/cards", checklists: "all")
      stub_request(:get, url).to_return(body: [api_card].to_json)

      result = described_class.call(
        filter: Subsequent::Filters::None,
        sort: Subsequent::Sorts::First,
        list_id: "other-list",
      )

      expect(a_request(:get, url)).to have_been_made.once
      expect(result.browse_list_id).to eq("other-list")
    end

    it "passes extra state args through" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      lists = [make_list]

      result = described_class.call(
        filter: Subsequent::Filters::None,
        sort: Subsequent::Sorts::First,
        lists:,
      )

      expect(result.lists).to eq(lists)
    end
  end
end
