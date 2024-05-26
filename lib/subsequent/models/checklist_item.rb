# frozen_string_literal: true

class Subsequent::Models::ChecklistItem
  attr_accessor :card_id, :id, :name, :pos, :state

  def self.from_data(checklist_items_data, card_id:)
    checklist_items_data.map { |item_data| new(card_id:, **item_data) }.sort
  end

  def initialize(card_id:, id:, name:, pos:, state:, **_item_data)
    self.card_id = card_id
    self.id = id
    self.name = name
    self.state = state
    self.pos = pos
  end

  def <=>(other)
    pos <=> other.pos
  end

  def checked?
    state == "complete"
  end

  def links
    name.scan(%r{https?://\S+})
  end
end
