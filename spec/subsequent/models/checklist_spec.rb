# frozen_string_literal: true

RSpec.describe Subsequent::Models::Checklist do
  describe "#initialize" do
    def check_item_data(pos:)
      { pos:, name: "Some Checklist", id: 5, state: "incomplete" }
    end

    it "sorts the check items by position" do
      check_items = [check_item_data(pos: 52), check_item_data(pos: 31)]

      checklist =
        described_class.new(id: 1, card_id: 1, name: "fo", pos: 1, check_items:)

      expect(checklist.items.map(&:pos)).to eq([31, 52])
    end
  end
end
