# frozen_string_literal: true

Subsequent::State =
  Data.define(
    :browsed_checklist,
    :browse_page,
    :cards,
    :card,
    :checklist,
    :checklist_items,
    :filter,
    :list_id,
    :lists,
    :mode,
    :sort,
    :tag_page,
  )

# class to handle state of the application
class Subsequent::State
  include Subsequent::DisplayHelpers

  DEFAULT_MODE = Subsequent::Modes::Normal
  CHECKLIST_ITEM_LIMIT = 5

  # the fields build derives, which callers must not preset
  SELECTED = [:card, :checklist, :checklist_items].freeze

  class << self
    # build a state for freshly fetched cards, selecting card and checklist
    def build(cards:, sort:, filter:, list_id:, **args)
      preset = args.keys & SELECTED
      unless preset.empty?
        raise ArgumentError, "build selects #{preset.join(", ")} itself"
      end

      new(cards: [], sort:, filter:, list_id:, **args).load(cards)
    end
  end

  def initialize(
    cards:,
    sort:,
    filter:,
    list_id:,
    browsed_checklist: false,
    browse_page: 0,
    card: Subsequent::Models::NullCard.new,
    checklist: Subsequent::Models::NullChecklist.new,
    checklist_items: [],
    lists: [],
    mode: DEFAULT_MODE,
    tag_page: 0
  )
    super
  end

  # replace the cards, applying the current filter and re-selecting
  def load(cards)
    with(cards: filter.call(cards)).reselect
  end

  # re-run the current sort to pick the card and its checklist
  def reselect
    select_card(sort.call(cards) || Subsequent::Models::NullCard.new)
  end

  # select the given card and its first checklist with unchecked items
  def select_card(card)
    with(card:).select_checklist(auto_checklist(card))
  end

  # select the given checklist on the current card
  def select_checklist(checklist)
    with(
      checklist:,
      checklist_items: checklist.unchecked_items.first(CHECKLIST_ITEM_LIMIT),
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

  # return the lists formatted for the current page
  def list_string
    paginated_string(lists, browse_page)
  end

  # return the browse cards formatted for the current page
  def browse_cards_string
    paginated_string(cards, browse_page)
  end

  # return checklists with unchecked items for the current card
  def browse_checklists
    card.checklists.select(&:unchecked_items?)
  end

  # return the browse checklists formatted for the current page
  def browse_checklists_string
    paginated_string(browse_checklists, browse_page)
  end

  # return the tags formatted for the current page
  def tag_string
    page_tags = tags.each_slice(9).to_a.fetch(tag_page, [])
    page_tags
      .map.with_index { |tag, index| "(#{cyan(index + 1)}) #{tag}" }
      .join("\n")
  end

  private

  def paginated_string(items, page)
    page_items = items.each_slice(9).to_a.fetch(page, [])
    page_items
      .map.with_index { |item, index| "(#{cyan(index + 1)}) #{item.name}" }
      .join("\n")
  end

  def auto_checklist(card)
    card.checklists.find(&:unchecked_items?) ||
      Subsequent::Models::NullChecklist.new
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
