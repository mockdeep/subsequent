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
    def initialize(cards:, sort:, filter:, **args)
      mode = args.fetch(:mode) { Subsequent::Modes::Normal }
      cards = filter.call(cards)
      card = sort.call(cards) || Subsequent::Models::NullCard.new
      checklist =
        args.fetch(:checklist) { card.checklists.find(&:unchecked_items?) }
      checklist ||= Subsequent::Models::NullChecklist.new
      checklist_items =
        args.fetch(:checklist_items) { checklist.unchecked_items.first(5) }

      super(
        cards:,
        filter:,
        sort:,
        card:,
        checklist:,
        checklist_items:,
        mode:,
      )
    end
  end
