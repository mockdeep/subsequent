# frozen_string_literal: true

module Factories
  def api_card
    { id: "123", name: "blah", pos: 1, short_url: "http://example.com", checklists: [api_checklist] }
  end

  def api_checklist(**overrides)
    { id: "456", name: "Checklist", pos: 1, check_items: [], **overrides }
  end

  def api_item
    { id: "5", name: "Check Item", pos: 1, state: "incomplete" }
  end

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

  def make_checklist(**overrides)
    Subsequent::Models::Checklist.new(
      card_id: 1,
      check_items: [],
      id: "456",
      name: "Checklist",
      pos: 1,
      items: [],
      **overrides,
    )
  end

  def make_checklist_item(**overrides)
    Subsequent::Models::ChecklistItem.new(
      id: 1,
      name: "Item",
      state: "incomplete",
      card_id: 1,
      pos: 1,
      **overrides,
    )
  end

  def make_state(**overrides)
    card = make_card
    Subsequent::State.format(
      cards: [card],
      filter: Subsequent::Filter::None,
      sort: Subsequent::Sort::First,
    ).with(**overrides)
  end
end

RSpec.configure do |config|
  config.include(Factories)
end
