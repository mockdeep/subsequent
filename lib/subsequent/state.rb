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
  )

# class to handle state of the application
class Subsequent::State
  include Subsequent::DisplayHelpers

  DEFAULT_MODE = Subsequent::Modes::Normal

  def initialize(cards:, sort:, filter:, mode: DEFAULT_MODE, **args)
    cards = filter.call(cards)
    card = sort.call(cards) || Subsequent::Models::NullCard.new
    checklist =
      args.fetch(:checklist) { card.checklists.find(&:unchecked_items?) }
    checklist ||= Subsequent::Models::NullChecklist.new
    checklist_items =
      args.fetch(:checklist_items) { checklist.unchecked_items.first(5) }

    super(cards:, filter:, sort:, card:, checklist:, checklist_items:, mode:)
  end

  # return tags for all cards
  def tags
    cards.flat_map(&:tags).uniq.sort
  end

  # return the card name formatted
  def title
    "#{card.name} - #{checklist.name} (#{link(card.short_url)})"
  end

  # return the checklist content formatted
  def checklist_string
    if checklist_items.any?
      checklist_items
        .map.with_index { |item, index| "#{index + 1}. #{item}" }.join("\n")
    else
      "No unchecked items, finish the card!"
    end
  end
end
