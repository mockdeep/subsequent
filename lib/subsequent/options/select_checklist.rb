# frozen_string_literal: true

# select a checklist from browse mode
module Subsequent::Options::SelectChecklist
  Subsequent::Options.register(self, :select_checklist)

  class << self
    # return true if text is a number in the current page's checklist range
    def match?(state, text)
      page_size = page_items(state).size
      return false if page_size.zero?

      ("1"..page_size.to_s).to_a.include?(text)
    end

    # set the selected checklist, transition to Normal
    def call(state, text)
      index = (state.browse_page * 9) + Integer(text) - 1
      checklist = state.browse_checklists.fetch(index)

      state.with(
        browsed_checklist: true,
        checklist:,
        checklist_items: checklist.unchecked_items.first(5),
        mode: Subsequent::Modes::Normal,
      )
    end

    private

    def page_items(state)
      state.browse_checklists.each_slice(9).to_a.fetch(state.browse_page, [])
    end
  end
end
