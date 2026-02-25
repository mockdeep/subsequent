# frozen_string_literal: true

Subsequent::State =
  Data.define(
    :browsed_checklist,
    :browse_list_id,
    :browse_page,
    :cards,
    :card,
    :checklist,
    :checklist_items,
    :filter,
    :lists,
    :mode,
    :sort,
    :tag_page,
  )

# class to handle state of the application
class Subsequent::State
  include Subsequent::DisplayHelpers

  DEFAULT_MODE = Subsequent::Modes::Normal

  def initialize(
    cards:,
    sort:,
    filter:,
    browsed_checklist: false,
    mode: DEFAULT_MODE,
    tag_page: 0,
    browse_list_id: nil,
    browse_page: 0,
    lists: [],
    **args
  )
    cards = filter.call(cards)
    card = derive_card(cards, sort, args)
    checklist = derive_checklist(card, args)
    checklist_items = derive_checklist_items(checklist, args)

    super(
      browsed_checklist:,
      browse_list_id:, browse_page:, cards:, filter:, lists:, sort:,
      card:, checklist:, checklist_items:, mode:, tag_page:,
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

  def derive_card(cards, sort, args)
    args.fetch(:card) { sort.call(cards) || Subsequent::Models::NullCard.new }
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
