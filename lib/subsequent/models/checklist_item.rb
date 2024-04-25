class Subsequent::Models::ChecklistItem
  attr_accessor :card_id, :id, :name, :state

  def initialize(card_id:, id:, name:, state:, **item_data)
    self.card_id = card_id
    self.id = id
    self.name = name
    self.state = state
  end

  def checked?
    state == "complete"
  end
end
