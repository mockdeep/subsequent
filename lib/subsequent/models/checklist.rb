# frozen_string_literal: true

# class to encapsulate a checklist
class Subsequent::Models::Checklist
  attr_accessor :id, :items, :name, :pos

  # Create a new array of checklists from the given data
  def self.from_data(checklists_data, card:)
    checklists_data
      .map { |checklist_data| new(card_id: card.id, **checklist_data) }
      .sort
  end

  def initialize(card_id:, id:, check_items:, name:, pos:, **_checklist_data)
    self.id = id
    self.name = name
    self.pos = pos
    self.items =
      Subsequent::Models::ChecklistItem.from_data(check_items, card_id:)
  end

  # compare the position of this checklist with another
  def <=>(other)
    pos <=> other.pos
  end

  # return whether the checklist has unchecked items
  def unchecked_items?
    unchecked_items.any?
  end

  # return the unchecked items in the checklist
  def unchecked_items
    items.reject(&:checked?)
  end

  # return a list of tags from the checklist name
  def tags
    tags = name.split.select { |tag| tag.start_with?("@") }

    tags.any? ? tags : ["<no tag>"]
  end
end
