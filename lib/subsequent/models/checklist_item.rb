class Subsequent::Models::ChecklistItem
  attr_accessor :card_id, :id, :name, :pos, :state

  def initialize(card_id:, id:, name:, pos:, state:, **item_data)
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
