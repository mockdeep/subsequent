# frozen_string_literal: true

# refresh the data
module Subsequent::Options::Refresh
  Subsequent::Options.register(self, :refresh)

  extend Subsequent::DisplayHelpers

  class << self
    # return true if the text is "r"
    def match?(_state, text)
      text == "r"
    end

    # refresh the data
    def call(state, _text)
      state => { filter:, sort:, browse_list_id:, lists: }

      new_state =
        show_spinner do
          Subsequent::Commands::FetchData.call(
            filter:, sort:, list_id: browse_list_id, lists:,
          )
        end

      restore_selection(new_state, state.card, state.checklist)
    end

    private

    def restore_selection(new_state, old_card, old_checklist)
      card = find_by_id(new_state.cards, old_card)
      return new_state unless card

      checklist = find_by_id(card.checklists, old_checklist)
      return new_state.with(card:) unless checklist

      new_state.with(
        card:,
        checklist:,
        checklist_items: checklist.unchecked_items.first(5),
      )
    end

    def find_by_id(collection, old_item)
      return unless old_item.respond_to?(:id)

      collection.find { |item| item.id == old_item.id }
    end
  end
end
