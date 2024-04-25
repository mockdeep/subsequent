class Subsequent::Models::Card
  attr_accessor :checklists

  def initialize(id:, **card_data)
    self.checklists =
      Subsequent::TrelloClient.fetch_checklists(id).map do |checklist_data|
        Subsequent::Models::Checklist.new(card_id: id, **checklist_data)
      end
  end
end
