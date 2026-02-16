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
    :tag_page,
  )

# class to handle state of the application
class Subsequent::State
  include Subsequent::DisplayHelpers

  DEFAULT_MODE = Subsequent::Modes::Normal

  def initialize(
    cards:, sort:, filter:, mode: DEFAULT_MODE, tag_page: 0, **args
  )
    cards = filter.call(cards)
    card = derive_card(cards, sort)
    checklist = derive_checklist(card, args)
    checklist_items = derive_checklist_items(checklist, args)

    super(
      cards:, filter:, sort:, card:, checklist:, checklist_items:, mode:,
      tag_page:,
    )
  end

  # return tags for all cards
  def tags
    tagged_checklists
      .map { |name, checklists| Subsequent::Models::Tag.new(name, checklists:) }
      .sort
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

  # return the tags formatted for the current page
  def tag_string
    page_tags = tags.each_slice(9).to_a.fetch(tag_page, [])
    page_tags
      .map.with_index { |tag, index| "(#{cyan(index + 1)}) #{tag}" }
      .join("\n")
  end

  private

  def derive_card(cards, sort)
    sort.call(cards) || Subsequent::Models::NullCard.new
  end

  def derive_checklist(card, args)
    checklist =
      args.fetch(:checklist) { card.checklists.find(&:unchecked_items?) }
    checklist || Subsequent::Models::NullChecklist.new
  end

  def derive_checklist_items(checklist, args)
    args.fetch(:checklist_items) { checklist.unchecked_items.first(5) }
  end

  def tagged_checklists
    pairs =
      active_checklists.flat_map do |checklist|
        checklist.tag_names.map { |name| [name, checklist] }
      end
    pairs.group_by(&:first).transform_values { |group| group.map(&:last) }
  end

  def active_checklists
    cards.flat_map(&:checklists).select(&:unchecked_items?)
  end
end
