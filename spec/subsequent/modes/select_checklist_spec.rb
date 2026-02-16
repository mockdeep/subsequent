# frozen_string_literal: true

RSpec.describe Subsequent::Modes::SelectChecklist do
  include Subsequent::DisplayHelpers

  def active_checklist(**overrides)
    api_checklist(check_items: [api_item], **overrides)
  end

  describe ".commands" do
    it "returns a list of commands with checklists" do
      card = make_card(checklists: [active_checklist(name: "My CL")])
      state = make_state(cards: [card])

      expect(described_class.commands(state)).to include("(#{cyan("1")}) My CL")
    end

    it "shows page indicator when multiple pages exist" do
      checklists =
        10.times.map { |i| active_checklist(id: i.to_s, name: "CL#{i}") }
      card = make_card(checklists:)
      state = make_state(cards: [card])

      expect(described_class.commands(state)).to include("page 1/2")
    end

    it "hides paging hints when only one page" do
      card = make_card(checklists: [active_checklist])
      state = make_state(cards: [card])

      expect(described_class.commands(state)).not_to include("page")
    end
  end

  describe ".handle_input" do
    it "returns to SelectCard when input is q" do
      state = make_state
      mock_input("q")

      result = described_class.handle_input(state)

      expect(result.mode).to eq(Subsequent::Modes::SelectCard)
    end

    it "returns state unchanged when input is something else" do
      state = make_state
      mock_input("z")

      expect(described_class.handle_input(state)).to eq(state)
    end
  end
end
