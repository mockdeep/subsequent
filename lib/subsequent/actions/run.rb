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
      catch(:quit) { loop { state = tick(state) } }
    end

    def tick(state)
      render(state)

      state.mode.handle_input(state)
    end

    def render(state)
      state => { card: }

      clear_screen
      print_title(card.name)
      output.puts(state.title)
      output.puts("=" * card.name.size)
      output.puts(state.checklist_string)
      output.puts
    end

    def print_title(name)
      output.print(terminal_title(name))
    end

    def initial_state
      sort = Subsequent::Sorts::First
      filter = Subsequent::Filters::None
      show_spinner { Subsequent::Commands::FetchData.call(filter:, sort:) }
    end
  end
end
