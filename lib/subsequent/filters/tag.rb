# frozen_string_literal: true

# filter by tag
class Subsequent::Filters::Tag
  attr_accessor :tag

  def initialize(tag)
    self.tag = tag
  end

  # returns a list of cards with checklists that have the tag
  def call(_cards)
    tag.checklists
       .select(&:unchecked_items?)
       .group_by(&:card)
       .each { |card, checklists| card.checklists = checklists }
       .keys
       .uniq
  end

  # returns true if the tag is the same as another tag
  def ==(other)
    other.respond_to?(:tag) && tag == other.tag
  end
end
