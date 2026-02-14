# frozen_string_literal: true

RSpec.describe Subsequent::Models::Tag do
  before { described_class.clear }

  describe ".find_or_create" do
    it "returns existing tag for same name" do
      tag1 = described_class.find_or_create("@tag")
      tag2 = described_class.find_or_create("@tag")

      expect(tag1).to equal(tag2)
    end

    it "creates new tag for different name" do
      tag1 = described_class.find_or_create("@alpha")
      tag2 = described_class.find_or_create("@beta")

      expect(tag1).not_to equal(tag2)
    end
  end

  describe ".clear" do
    it "resets the tag registry" do
      described_class.find_or_create("@tag")
      described_class.clear
      tag = described_class.find_or_create("@tag")

      expect(tag.checklists).to be_empty
    end
  end

  describe "#add_checklist" do
    it "adds a checklist to the tag" do
      tag = make_tag
      checklist = make_checklist

      tag.add_checklist(checklist)

      expect(tag.checklists).to include(checklist)
    end

    it "replaces stale reference with same id" do
      tag = make_tag
      tag.add_checklist(make_checklist(id: "abc"))
      tag.add_checklist(make_checklist(id: "abc"))

      expect(tag.checklists.size).to eq(1)
    end
  end

  describe "#items" do
    it "returns unchecked items across all associated checklists" do
      tag = make_tag
      checklist = make_checklist
      checklist.items << make_checklist_item
      tag.add_checklist(checklist)

      expect(tag.items.size).to eq(1)
    end
  end

  describe "#to_s" do
    it "returns name with item count" do
      tag = make_tag("@focus")
      checklist = make_checklist
      checklist.items << make_checklist_item
      tag.add_checklist(checklist)

      expect(tag.to_s).to eq("@focus (1)")
    end
  end

  describe "#==" do
    it "returns true when compared with matching string" do
      tag = make_tag("@tag")

      expect(tag == "@tag").to be(true)
    end

    it "returns false when compared with non-matching string" do
      tag = make_tag("@tag")

      expect(tag == "@other").to be(false)
    end

    it "returns true when compared with tag of same name" do
      tag1 = make_tag("@tag")
      tag2 = make_tag("@tag")

      expect(tag1 == tag2).to be(true)
    end
  end

  describe "<=>" do
    it "returns -1 if the tag name is less than the other tag name" do
      tag1 = make_tag("@alpha")
      tag2 = make_tag("@beta")

      expect(tag1 <=> tag2).to eq(-1)
    end

    it "returns 1 if the tag name is greater than the other tag name" do
      tag1 = make_tag("@beta")
      tag2 = make_tag("@alpha")

      expect(tag1 <=> tag2).to eq(1)
    end

    it "returns 0 if the tag names are equal" do
      tag1 = make_tag("@tag")
      tag2 = make_tag("@tag")

      expect(tag1 <=> tag2).to eq(0)
    end
  end
end
