# frozen_string_literal: true

RSpec.describe Subsequent::Models::Tag do
  describe "#items" do
    it "returns unchecked items across all associated checklists" do
      checklist = make_checklist(check_items: [api_item])
      tag = make_tag("@focus", checklists: [checklist])

      expect(tag.items.size).to eq(1)
    end
  end

  describe "#to_s" do
    it "returns name with item count" do
      checklist = make_checklist(check_items: [api_item])
      tag = make_tag("@focus", checklists: [checklist])

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
