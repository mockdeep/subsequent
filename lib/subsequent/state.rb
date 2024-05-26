# frozen_string_literal: true

Subsequent::State =
  Data.define(:cards, :card, :checklist, :checklist_items, :mode, :sort) do
    # return new state based on cards and sort
    def self.format(cards:, sort:)
      card = sort.call(cards)
      checklist = card.checklists.find(&:unchecked_items?)
      checklist_items = checklist&.unchecked_items&.first(5)

      Subsequent::State
        .new(cards:, card:, checklist:, checklist_items:, sort:, mode: :normal)
    end
  end
