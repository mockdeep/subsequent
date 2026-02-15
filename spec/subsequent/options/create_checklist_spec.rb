# frozen_string_literal: true

RSpec.describe Subsequent::Options::CreateChecklist do
  describe ".match?" do
    it "always returns true" do
      expect(described_class.match?(make_state, "anything")).to be(true)
    end
  end

  describe ".call" do
    it "returns state with AddChecklistItem mode" do
      stub_request(:post, /checklists/).to_return(body: api_checklist.to_json)
      stub_request(:get, /cards/).to_return(body: [api_card].to_json)

      result = described_class.call(make_state, "New Checklist")

      expect(result.mode).to eq(Subsequent::Modes::AddChecklistItem)
    end
  end
end
