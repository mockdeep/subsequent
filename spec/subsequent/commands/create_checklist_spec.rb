# frozen_string_literal: true

RSpec.describe Subsequent::Commands::CreateChecklist do
  describe ".call" do
    it "creates a checklist via API on the current card" do
      state = make_state
      post_url = api_url(
        "checklists",
        idCard: state.card.id,
        name: "My List",
        pos: "top",
      )
      stub_request(:post, post_url)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      described_class.call(state, "My List")

      expect(a_request(:post, post_url)).to have_been_made.once
    end

    it "re-fetches data after creation" do
      state = make_state
      stub_request(:post, /checklists/)
      get_url = api_url("lists/test-list-id/cards", checklists: "all")
      stub_request(:get, get_url).to_return(body: [api_card].to_json)

      described_class.call(state, "My List")

      expect(a_request(:get, get_url)).to have_been_made.once
    end

    it "returns state with AddChecklistItem mode and checklist items" do
      state = make_state
      stub_request(:post, /checklists/)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      result = described_class.call(state, "My List")

      expect(result.mode).to eq(Subsequent::Modes::AddChecklistItem)
    end
  end
end
