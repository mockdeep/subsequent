# frozen_string_literal: true

RSpec.describe Subsequent::Models::ChecklistItem do
  def check_item_data(**overrides)
    {
      card_id: 1,
      pos: 1,
      name: "Some Checklist",
      id: 5,
      state: "incomplete",
      **overrides,
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

  describe "#checked?" do
    it "returns true when state is complete" do
      item = described_class.new(**check_item_data(state: "complete"))

      expect(item.checked?).to be(true)
    end

    it "returns false when state is incomplete" do
      item = described_class.new(**check_item_data(state: "incomplete"))

      expect(item.checked?).to be(false)
    end
  end

  describe "#icon" do
    it "returns a checkmark when checked" do
      item = described_class.new(**check_item_data(state: "complete"))

      expect(item.icon).to eq("✔")
    end

    it "returns an empty box when unchecked" do
      item = described_class.new(**check_item_data(state: "incomplete"))

      expect(item.icon).to eq("☐")
    end
  end

  describe "#formatted_name" do
    it "returns green name when unchecked" do
      item = described_class.new(**check_item_data(state: "incomplete"))

      expect(item.formatted_name).to eq("\e[32mSome Checklist\e[0m")
    end

    it "returns gray name when checked" do
      item = described_class.new(**check_item_data(state: "complete"))

      expect(item.formatted_name).to eq("\e[94mSome Checklist\e[0m")
    end
  end

  describe "#to_s" do
    it "returns icon and formatted name" do
      item = described_class.new(**check_item_data(state: "incomplete"))

      expect(item.to_s).to eq("☐ \e[32mSome Checklist\e[0m")
    end
  end

  describe ".from_data" do
    it "builds a sorted array of checklist items from raw data" do
      data = [
        { id: 2, name: "Second", pos: 20, state: "incomplete" },
        { id: 1, name: "First", pos: 10, state: "complete" },
      ]

      items = described_class.from_data(data, card_id: 1)

      expect(items.map(&:name)).to eq(["First", "Second"])
      expect(items.map(&:pos)).to eq([10, 20])
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
