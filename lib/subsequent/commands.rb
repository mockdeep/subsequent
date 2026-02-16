# frozen_string_literal: true

# module to encapsulate commands
module Subsequent::Commands
end

require_relative "commands/archive_card"
require_relative "commands/create_checklist"
require_relative "commands/fetch_data"
require_relative "commands/fetch_lists"
require_relative "commands/open_links"
require_relative "commands/toggle_checklist_item"
