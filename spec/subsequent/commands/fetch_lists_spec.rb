# frozen_string_literal: true

RSpec.describe Subsequent::Commands::FetchLists do
  describe ".call" do
    it "fetches lists from Trello API" do
      url = api_url("boards/test-board-id/lists", filter: "open")
      stub_request(:get, url).to_return(body: [api_list].to_json)

      described_class.call(make_state)

      expect(a_request(:get, url)).to have_been_made.once
    end

    it "returns state with SelectList mode" do
      stub_request(:get, /lists/).to_return(body: [api_list].to_json)

      result = described_class.call(make_state)

      expect(result.mode).to eq(Subsequent::Modes::SelectList)
    end

    it "returns state with fetched lists" do
      stub_request(:get, /lists/).to_return(body: [api_list].to_json)

      result = described_class.call(make_state)

      expect(result.lists.first.name).to eq("List One")
    end

    it "resets browse_page to 0" do
      stub_request(:get, /lists/).to_return(body: [api_list].to_json)

      result = described_class.call(make_state(browse_page: 1))

      expect(result.browse_page).to eq(0)
    end
  end
end
