# frozen_string_literal: true

RSpec.describe Subsequent::Modes::AddChecklistItem do
  include Subsequent::DisplayHelpers

  describe ".commands" do
    it "returns the command string" do
      expect(described_class.commands(nil))
        .to eq("enter checklist item name (#{cyan("q")}) to cancel: ")
    end
  end

  describe ".handle_input" do
    it "returns state with mode Normal when input is empty" do
      expect(described_class.handle_input(make_state))
        .to eq(make_state(mode: Subsequent::Modes::Normal))
    end

    it "returns state with mode Normal when input is q" do
      input.puts("q")

      expect(described_class.handle_input(make_state))
        .to eq(make_state(mode: Subsequent::Modes::Normal))
    end

    it "creates a checklist item with the input text" do
      checklist = make_checklist
      state = make_state(cards: [make_card_with_item], checklist:)
      stub_request(:post, /checkItems/)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      mock_input("new item")

      result = described_class.handle_input(state)

      expect(result.mode).to eq(Subsequent::Modes::AddChecklistItem)
    end
  end
end
