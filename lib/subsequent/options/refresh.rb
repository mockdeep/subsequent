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

      restore_selection(new_state, state)
    end

    private

    def restore_selection(new_state, old_state)
      card = find_by_id(new_state.cards, old_state.card)
      return new_state unless card

      checklist = restore_checklist(card, old_state)

      new_state.with(
        browsed_checklist: old_state.browsed_checklist,
        card:,
        checklist:,
        checklist_items: checklist.unchecked_items.first(5),
      )
    end

    def restore_checklist(card, old_state)
      if old_state.browsed_checklist
        checklist = find_by_id(card.checklists, old_state.checklist)
        checklist = nil unless checklist&.unchecked_items?
      end
      checklist || card.checklists.find(&:unchecked_items?) ||
        Subsequent::Models::NullChecklist.new
    end

    def find_by_id(collection, old_item)
      return unless old_item.respond_to?(:id)

      collection.find { |item| item.id == old_item.id }
    end
  end
end
