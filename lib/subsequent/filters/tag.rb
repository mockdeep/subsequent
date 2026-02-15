# frozen_string_literal: true

# filter by tag
class Subsequent::Filters::Tag
  attr_reader :tag_name

  def initialize(tag_name)
    @tag_name = tag_name
  end

  # returns a list of cards with checklists that have the tag
  def call(cards)
    cards.each_with_object([]) do |card, result|
      matching =
        card.checklists.select do |checklist|
          checklist.unchecked_items? && checklist.tag_names.include?(tag_name)
        end
      next if matching.empty?

      result << card.with(checklists: matching)
    end
  end

  # returns true if the tag name is the same as another tag name
  def ==(other)
    other.respond_to?(:tag_name) && tag_name == other.tag_name
  end
end
