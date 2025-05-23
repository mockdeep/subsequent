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

  describe "#<=>" do
    it "compares the position of two checklists" do
      checklist1 = make_checklist(pos: 2)
      checklist2 = make_checklist(pos: 1)

      expect([checklist1, checklist2].sort).to eq([checklist2, checklist1])
    end
  end

  describe "#tags" do
    it "returns the tags from the checklist name" do
      checklist = make_checklist(name: "foo @bar baz @qux")

      expect(checklist.tags).to eq(["@bar", "@qux"])
    end

    it "returns <no tag> if no tags are present" do
      checklist = make_checklist(name: "foo bar baz")

      expect(checklist.tags).to eq(["<no tag>"])
    end
  end
end
