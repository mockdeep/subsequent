# frozen_string_literal: true

# filter by tag
class Subsequent::Filters::Tag
  attr_accessor :tag

  def initialize(tag)
    self.tag = tag
  end

  # returns a list of cards with checklists that have the tag
  def call(cards)
    cards.each do |card|
      card.checklists =
        card.checklists.select do |checklist|
          checklist.unchecked_items? && checklist.tags.include?(tag)
        end
    end

    cards.select { |card| card.checklists.any? }
  end

  # returns true if the tag is the same as another tag
  def ==(other)
    other.respond_to?(:tag) && tag == other.tag
  end
end
