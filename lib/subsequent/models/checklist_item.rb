# frozen_string_literal: true

# class to encapsulate a checklist item
class Subsequent::Models::ChecklistItem
  include Subsequent::DisplayHelpers

  LOADING_FRAMES = ["○", "◑", "●", "◑"].freeze

  attr_accessor :card_id, :id, :name, :pos, :state

  class << self
    # create a new array of checklist items from the given data
    def from_data(checklist_items_data, card_id:)
      checklist_items_data.map { |item_data| new(card_id:, **item_data) }.sort
    end
  end

  def initialize(card_id:, id:, name:, pos:, state:, **_item_data)
    self.card_id = card_id
    self.id = id
    self.name = name
    self.state = state
    self.pos = pos
  end

  # compare the position of this checklist item with another
  def <=>(other)
    pos <=> other.pos
  end

  # return whether the checklist item is checked
  def checked?
    state == "complete"
  end

  # return whether the checklist item is loading
  def loading?
    state == "loading"
  end

  # return the icon for the checklist item
  def icon
    return loading_spinner.next if loading?

    checked? ? "✔" : "☐"
  end

  # return the loading spinner enumerator for this item
  def loading_spinner
    @loading_spinner ||= LOADING_FRAMES.cycle
  end

  # return the links in the checklist item name
  def links
    name.scan(%r{https?://\S+})
  end

  # return the name linkified and colored
  def formatted_name
    linked_name = linkify(name)
    return yellow(linked_name) if loading?

    checked? ? gray(linked_name) : green(linked_name)
  end

  # return a formatted string representation of the checklist item
  def to_s
    "#{icon} #{formatted_name}"
  end
end
