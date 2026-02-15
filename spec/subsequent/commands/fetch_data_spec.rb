# frozen_string_literal: true

RSpec.describe Subsequent::Commands::FetchData do
  describe ".call" do
    before do
      Subsequent::Models::Tag.clear
    end

    it "fetches cards from Trello API" do
      get_url = api_url("lists/test-list-id/cards", checklists: "all")
      stub_request(:get, get_url).to_return(body: [api_card].to_json)

      described_class.call(
        filter: Subsequent::Filters::None,
        sort: Subsequent::Sorts::First,
      )

      expect(a_request(:get, get_url)).to have_been_made.once
    end

    it "clears and reloads tags" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      Subsequent::Models::Tag.find_or_create("@old")

      described_class.call(
        filter: Subsequent::Filters::None,
        sort: Subsequent::Sorts::First,
      )

      expect(Subsequent::Models::Tag.find_or_create("@old"))
        .not_to have_attributes(checklists: include(anything))
    end

    it "updates filter tag reference when filter is a Tag filter" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      tag = make_tag
      filter = Subsequent::Filters::Tag.new(tag)

      described_class.call(filter:, sort: Subsequent::Sorts::First)

      expect(filter.tag).to eq(Subsequent::Models::Tag.find_or_create(tag.name))
    end

    it "preserves filter when filter is not a Tag filter" do
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      filter = Subsequent::Filters::None

      result = described_class.call(filter:, sort: Subsequent::Sorts::First)

      expect(result.filter).to eq(Subsequent::Filters::None)
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
  end
end
