# frozen_string_literal: true

class Subsequent::Models::Card
  attr_accessor :checklists, :id, :name, :pos, :short_url

  def initialize(id:, name:, pos:, short_url:, checklists:, **_card_data)
    self.id = id
    self.pos = pos
    self.checklists =
      checklists.map do |checklist_data|
        Subsequent::Models::Checklist.new(card_id: id, **checklist_data)
      end.sort
    self.name = name
    self.short_url = short_url
  end
end
