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
      hide_cursor
      catch(:quit) { loop { state = tick(state) } }
    ensure
      show_cursor
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
      filter = build_filter

      show_spinner do
        list_id = resolve_list_id
        Subsequent::Commands::FetchData.call(filter:, sort:, list_id:)
      end
    end

    def build_filter
      tag_name = Subsequent::Configuration.tag_name
      return Subsequent::Filters::None unless tag_name

      Subsequent::Filters::Tag.new(tag_name)
    end

    def resolve_list_id
      list_name = Subsequent::Configuration.list_name
      return unless list_name

      list =
        Subsequent::TrelloClient.fetch_lists.find do |candidate|
          candidate.name == list_name
        end
      raise Subsequent::Error, "Unknown list: #{list_name}" unless list

      list.id
    end
  end
end
