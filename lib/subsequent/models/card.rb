class Subsequent::Models::Card
  attr_accessor :checklists, :name, :short_url

  def initialize(id:, name:, short_url:, checklists:, **card_data)
    self.checklists =
      checklists.map do |checklist_data|
        Subsequent::Models::Checklist.new(card_id: id, **checklist_data)
      end.sort
    self.name = name
    self.short_url = short_url
  end
end
