# frozen_string_literal: true

# Open links from card or checklist items
module Subsequent::Commands::OpenLinks
  class << self
    # Open links
    def call(state)
      state => { card:, checklist_items: }

      links = checklist_items.flat_map(&:links)
      links = [card.short_url] if links.blank?

      links.each do |link|
        system("open", link)

        # otherwise system can open links in inconsistent order
        sleep(0.1)
      end

      state
    end
  end
end
