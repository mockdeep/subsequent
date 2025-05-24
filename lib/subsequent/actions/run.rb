# frozen_string_literal: true

# module that runs the application
module Subsequent::Actions::Run
  extend Subsequent::DisplayHelpers
  extend Subsequent::Configuration::Helpers

  class << self
    # Run the application
    def call(*args)
      Subsequent::Configuration.parse(args)
      start_loop(initial_state)
    end

    private

    def start_loop(state)
      loop do
        state => { card:, mode: }

        clear_screen
        output.puts state.title
        output.puts "=" * card.name.size
        output.puts state.checklist_string

        output.puts

        state = mode.handle_input(state)
      end
    end

    def initial_state
      sort = Subsequent::Sorts::First
      filter = Subsequent::Filters::None
      show_spinner { Subsequent::Commands::FetchData.call(filter:, sort:) }
    end
  end
end
