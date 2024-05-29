# frozen_string_literal: true

RSpec.describe Subsequent::Mode::AddCard do
  include Subsequent::DisplayHelpers
  include Subsequent::Configuration::Helpers

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
      checklist: nil,
      checklist_items: [],
      mode: Subsequent::Mode::AddChecklist,
      sort: Subsequent::Sort::First,
      **overrides,
    )
  end

  it "returns state to normal mode with the same card" do
    input.puts("Card Name")
    input.puts("q")

    state = make_state
    expect(described_class.handle_input(state))
      .to eq(state.with(mode: Subsequent::Mode::Normal))
  end

  it "returns state with normal mode when input is empty" do
    state = make_state
    expect(described_class.handle_input(state))
      .to eq(state.with(mode: Subsequent::Mode::Normal))
  end

  it "returns state with normal mode when input is q" do
    input.puts("q")

    state = make_state
    expect(described_class.handle_input(state))
      .to eq(state.with(mode: Subsequent::Mode::Normal))
  end
end
