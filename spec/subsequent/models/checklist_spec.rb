# frozen_string_literal: true

RSpec.describe Subsequent::Models::Checklist do
  describe "#initialize" do
    def check_item_data(pos:)
      { pos:, name: "Some Checklist", id: 5, state: "incomplete" }
    end

    it "sorts the check items by position" do
      check_items = [check_item_data(pos: 52), check_item_data(pos: 31)]
      card = make_card

      checklist =
        described_class.new(id: 1, card:, name: "fo", pos: 1, check_items:)

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

  describe "#eql?" do
    it "returns true if the checklists have the same id" do
      checklist1 = make_checklist(id: "abc")
      checklist2 = make_checklist(id: "abc")

      expect(checklist1.eql?(checklist2)).to be(true)
    end

    it "returns false if the checklists have different ids" do
      checklist1 = make_checklist(id: "abc")
      checklist2 = make_checklist(id: "def")

      expect(checklist1.eql?(checklist2)).to be(false)
    end
  end

  describe "#unchecked_items?" do
    it "returns true when unchecked items exist" do
      checklist = make_checklist
      checklist.items << make_checklist_item(state: "incomplete")

      expect(checklist.unchecked_items?).to be(true)
    end

    it "returns false when all items are checked" do
      checklist = make_checklist
      checklist.items << make_checklist_item(state: "complete")

      expect(checklist.unchecked_items?).to be(false)
    end
  end

  describe "#unchecked_items" do
    it "returns only unchecked items" do
      checklist = make_checklist
      checklist.items << make_checklist_item(id: 1, state: "incomplete")
      checklist.items << make_checklist_item(id: 2, state: "complete")
      checklist.items << make_checklist_item(id: 3, state: "incomplete")

      expect(checklist.unchecked_items.map(&:id)).to eq([1, 3])
    end
  end

  describe "#hash" do
    it "returns the hash of the checklist id" do
      checklist = make_checklist(id: "abc")

      expect(checklist.hash).to eq("abc".hash)
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
