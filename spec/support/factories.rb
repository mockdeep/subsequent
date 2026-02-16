# frozen_string_literal: true

module Factories
  def api_card
    { id: "123", name: "blah", pos: 1, short_url: "http://example.com", checklists: [api_checklist] }
  end

  def api_checklist(**overrides)
    { id: "456", name: "Checklist", pos: 1, check_items: [], **overrides }
  end

  def api_list(**overrides)
    { id: "list-1", name: "List One", **overrides }
  end

  def api_item(**overrides)
    { id: "5", name: "Check Item", pos: 1, state: "incomplete", **overrides }
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

  def make_list(**overrides)
    Subsequent::Models::List.new(id: "list-1", name: "List One", **overrides)
  end

  def make_checklist(**overrides)
    Subsequent::Models::Checklist.new(
      card_id: 1,
      check_items: [],
      id: "456",
      name: "Checklist",
      pos: 1,
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

  def make_card_with_item
    make_card(checklists: [api_checklist(check_items: [api_item])])
  end

  def make_state(cards: [make_card], **overrides)
    Subsequent::State.new(
      cards:,
      filter: Subsequent::Filters::None,
      sort: Subsequent::Sorts::First,
      **overrides,
    )
  end

  def make_tag(tag_name = "@tag", checklists: [])
    Subsequent::Models::Tag.new(tag_name, checklists:)
  end
end

RSpec.configure do |config|
  config.include(Factories)
end
