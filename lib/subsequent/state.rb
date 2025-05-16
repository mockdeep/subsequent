# frozen_string_literal: true

Subsequent::State =
  Data.define(
    :cards,
    :card,
    :checklist,
    :checklist_items,
    :filter,
    :mode,
    :sort,
  ) do
    # return new state based on cards and sort
    def self.format(cards:, filter:, sort:)
      cards = filter.call(cards)
      card = sort.call(cards) || Subsequent::Models::NullCard.new
      checklist = card.checklists.find(&:unchecked_items?)
      checklist ||= Subsequent::Models::NullChecklist.new
      checklist_items = checklist.unchecked_items.first(5)
      mode = Subsequent::Modes::Normal

      Subsequent::State
        .new(cards:, card:, checklist:, checklist_items:, filter:, mode:, sort:)
    end
  end
