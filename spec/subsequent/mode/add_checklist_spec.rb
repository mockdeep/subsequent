# frozen_string_literal: true

RSpec.describe Subsequent::Mode::AddChecklist do
  include Subsequent::DisplayHelpers

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
      stub_request(:post, /checklists/)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)
      mock_input("new checklist")

      result = described_class.handle_input(make_state)

      expect(result.checklist.name).to eq("Checklist")
    end
  end
end
