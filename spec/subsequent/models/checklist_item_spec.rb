# frozen_string_literal: true

RSpec.describe Subsequent::Models::ChecklistItem do
  def check_item_data(**overrides)
    {
      card_id: 1,
      pos: 1,
      name: "Some Checklist",
      id: 5,
      state: "incomplete",
      **overrides
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

  describe "#links" do
    it "returns an empty array when there are no links in the name" do
      check_item = described_class.new(**check_item_data)

      expect(check_item.links).to eq([])
    end

    it "returns an array of links when there are links in the name" do
      name = "foo https://example.com bar https://example.org baz"
      check_item = described_class.new(**check_item_data(name:))

      expect(check_item.links)
        .to eq(["https://example.com", "https://example.org"])
    end
  end
end
