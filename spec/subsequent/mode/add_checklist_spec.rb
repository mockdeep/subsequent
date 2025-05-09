# frozen_string_literal: true

RSpec.describe Subsequent::Mode::AddChecklist do
  include Subsequent::DisplayHelpers
  include Subsequent::Configuration::Helpers

  describe ".commands" do
    it "returns the command array" do
      expect(described_class.commands(nil))
        .to eq(["enter checklist name (#{cyan("q")}) to cancel: "])
    end
  end

  describe ".handle_input" do
    it "returns state with mode Normal when input is empty" do
      expect(described_class.handle_input(make_state))
        .to eq(make_state(mode: Subsequent::Mode::Normal))
    end

    it "returns state with mode Normal when input is q" do
      input.puts("q")

      expect(described_class.handle_input(make_state))
        .to eq(make_state(mode: Subsequent::Mode::Normal))
    end

    it "creates a checklist with the input text" do
      post_url = "https://api.trello.com/1/checklists?idCard=1&key=test-key&name=new%20checklist&pos=top&token=test-token"
      get_url = "https://api.trello.com/1/lists/test-list-id/cards?checklists=all&key=test-key&token=test-token"
      stub_request(:post, post_url)
      stub_request(:get, get_url).to_return(body: [api_card].to_json)
      state = make_state
      input.puts("new checklist")
      input.rewind

      result = described_class.handle_input(state)

      expect(result.checklist.name).to eq("Checklist")
    end
  end
end
