# frozen_string_literal: true

RSpec.describe Subsequent::Mode::Sort do
  def make_card(**overrides)
    Subsequent::Models::Card.new(
      id: 1,
      name: "Card Name",
      pos: 1,
      description: "Card Description",
      checklists: [],
      short_url: "http://example.com",
      **overrides,
    )
  end

  def make_state(**overrides)
    card = make_card
    Subsequent::State.new(
      card:,
      cards: [card],
      checklist: Subsequent::Models::NullChecklist.new,
      checklist_items: [],
      mode: Subsequent::Mode::Sort,
      sort: Subsequent::Sort::First,
      **overrides,
    )
  end

  describe ".handle_input" do
    it "returns state with mode Normal when input is q" do
      state = make_state
      mock_input("q")

      expect(described_class.handle_input(state))
        .to eq(state.with(mode: Subsequent::Mode::Normal))
    end

    it "returns state unchanged when input is something else" do
      state = make_state
      mock_input("z")

      expect(described_class.handle_input(state)).to eq(state)
    end

    it "returns state with sort mode when input is f, l, or m" do
      state = make_state
      mock_input("m")

      new_sort = Subsequent::Sort::MostUncheckedItems

      expect(described_class.handle_input(state))
        .to eq(state.with(sort: new_sort, mode: Subsequent::Mode::Normal))
    end
  end
end
