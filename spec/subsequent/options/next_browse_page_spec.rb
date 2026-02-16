# frozen_string_literal: true

RSpec.describe Subsequent::Options::NextBrowsePage do
  def many_checklists
    10.times.map do |i|
      api_checklist(id: i.to_s, name: "CL#{i}", check_items: [api_item])
    end
  end

  describe ".match?" do
    it "returns true when more list pages exist" do
      lists = 10.times.map { |i| make_list(id: i.to_s, name: "L#{i}") }
      state = make_state(lists:, mode: Subsequent::Modes::SelectList)

      expect(described_class.match?(state, ">")).to be(true)
    end

    it "returns false when on last list page" do
      lists = [make_list]
      state = make_state(lists:, mode: Subsequent::Modes::SelectList)

      expect(described_class.match?(state, ">")).to be(false)
    end

    it "returns true when more card pages exist" do
      cards = 10.times.map { |i| make_card(id: i, name: "C#{i}") }
      state = make_state(cards:, mode: Subsequent::Modes::SelectCard)

      expect(described_class.match?(state, ">")).to be(true)
    end

    it "returns true when more checklist pages exist" do
      card = make_card(checklists: many_checklists)
      mode = Subsequent::Modes::SelectChecklist
      state = make_state(cards: [card], mode:)

      expect(described_class.match?(state, ">")).to be(true)
    end

    it "returns false for unknown mode" do
      state = make_state(mode: Subsequent::Modes::Normal)

      expect(described_class.match?(state, ">")).to be(false)
    end

    it "returns false when text is not >" do
      lists = 10.times.map { |i| make_list(id: i.to_s, name: "L#{i}") }
      state = make_state(lists:, mode: Subsequent::Modes::SelectList)

      expect(described_class.match?(state, "x")).to be(false)
    end
  end

  describe ".call" do
    it "increments the browse page" do
      state = make_state(browse_page: 0)

      expect(described_class.call(state, ">").browse_page).to eq(1)
    end
  end
end
