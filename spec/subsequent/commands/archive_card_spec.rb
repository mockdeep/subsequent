# frozen_string_literal: true

RSpec.describe Subsequent::Commands::ArchiveCard do
  describe ".call" do
    it "archives the card via API when user confirms" do
      mock_input("y")
      state = make_state
      put_url = api_url("cards/#{state.card.id}", closed: true)
      stub_request(:put, put_url).to_return(body: "{}")
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      described_class.call(state)

      expect(a_request(:put, put_url)).to have_been_made.once
    end

    it "returns original state when user declines" do
      mock_input("n")
      state = make_state

      result = described_class.call(state)

      expect(result).to eq(state)
    end

    it "re-fetches data after archiving" do
      mock_input("y")
      state = make_state
      stub_request(:put, /cards/).to_return(body: "{}")
      get_url = api_url("lists/test-list-id/cards", checklists: "all")
      stub_request(:get, get_url).to_return(body: [api_card].to_json)

      described_class.call(state)

      expect(a_request(:get, get_url)).to have_been_made.once
    end

    it "passes filter and sort through to FetchData" do
      mock_input("y")
      sort = Subsequent::Sorts::MostUncheckedItems
      state = make_state(sort:)
      stub_request(:put, /cards/).to_return(body: "{}")
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      result = described_class.call(state)

      expect(result.sort).to eq(sort)
    end
  end
end
