# frozen_string_literal: true

RSpec.describe Subsequent::Models::ChecklistItem do
  def check_item_data(pos:)
    {
      card_id: 1,
      pos:,
      name: "Some Checklist",
      id: 5,
      state: "incomplete"
    }
  end

  describe "#<=>" do
    it "returns -1 when the other item has a higher position" do
      check_item = described_class.new(**check_item_data(pos: 1))
      other_item = described_class.new(**check_item_data(pos: 2))

      expect(check_item <=> other_item).to eq(-1)
    end

    it "returns 1 when the other item has a lower position" do
      check_item = described_class.new(**check_item_data(pos: 2))
      other_item = described_class.new(**check_item_data(pos: 1))

      expect(check_item <=> other_item).to eq(1)
    end

    it "returns 0 when the other item has the same position" do
      check_item = described_class.new(**check_item_data(pos: 1))
      other_item = described_class.new(**check_item_data(pos: 1))

      expect(check_item <=> other_item).to eq(0)
    end
  end
end
