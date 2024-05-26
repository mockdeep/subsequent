module Subsequent::Actions::Run

  State = Data.define(:cards, :card, :checklist, :checklist_items, :mode, :sort)

  extend Subsequent::TextFormatting
  extend Subsequent::Configuration::Helpers

  DISPLAY_COUNT = 5

  def self.call
    state = fetch_data(sort: Subsequent::Sort::First)

    loop do
      state => { card:, checklist:, checklist_items: }

      output.clear_screen
      output.puts "#{card.name} (#{link(card.short_url)})"
      output.puts "=" * card.name.size
      if checklist
        checklist_items.each_with_index do |item, index|
          icon = item.checked? ? "✔" : "☐"
          item_name = linkify(item.name)
          name = item.checked? ? gray(item_name) : green(item_name)
          output.puts "#{index + 1}. #{icon} #{name}"
        end
      else
        output.puts "No unchecked items, finish the card!"
      end

      output.puts
      output.puts commands(state)

      state = handle_input(state)
    end
  end

  def self.commands(state)
    state => { mode: }

    case mode
    when :normal
      Subsequent::Mode::Normal.commands(state)
    when :cycle
      Subsequent::Mode::Cycle.commands(state)
    when :sort
      Subsequent::Mode::Sort.commands(state)
    end
  end

  def self.fetch_data(sort:)
    cards = load_cards

    format_state(cards:, sort:)
  end

  def self.format_state(cards:, sort:)
    card = sort.call(cards)
    checklist = card.checklists.find(&:unchecked_items?)
    checklist_items =
      checklist && checklist.unchecked_items.first(DISPLAY_COUNT)

    State.new(cards:, card:, checklist:, checklist_items:, sort:, mode: :normal)
  end

  def self.load_cards
    Subsequent::Actions::Spin.call do
      Subsequent::TrelloClient.fetch_cards
    end
  end

  def self.handle_input(state)
    state => { checklist_items:, mode:, sort: }

    if mode == :cycle
      return cycle(state)
    elsif mode == :sort
      return sort(state)
    end

    char = input.getch

    case char
    when ("1"..checklist_items.to_a.size.to_s)
      toggle_checklist_item(state, char)
    when "r"
      fetch_data(sort:)
    when "s"
      State.new(**state.to_h, mode: :sort)
    when "c"
      State.new(**state.to_h, mode: :cycle)
    when "o"
      open_links(state)
    when "a"
      archive_card(state)
    when "q", "\u0004", "\u0003"
      output.puts yellow("Goodbye!")
      exit
    else
      state
    end
  end

  def self.toggle_checklist_item(state, char)
    state => { checklist_items: }

    task_number = Integer(char)
    item = checklist_items[task_number - 1]

    Subsequent::TrelloClient.toggle_checklist_item(item)

    state
  end

  def self.cycle(state)
    state => { cards:, card:, checklist:, checklist_items:, sort: }

    char = input.getch

    case char
    when "q", "\u0004", "\u0003"
      State.new(**state.to_h, mode: :normal)
    when "i"
      checklist_item = checklist_items.first
      pos = checklist.items.last.pos + 1
      Subsequent::TrelloClient.update_checklist_item(checklist_item, pos:)
      fetch_data(sort:)
    when "l"
      pos = card.checklists.last.pos + 1
      Subsequent::TrelloClient.update_checklist(checklist, pos:)
      fetch_data(sort:)
    when "c"
      pos = cards.last.pos + 1
      Subsequent::TrelloClient.update_card(card, pos:)
      fetch_data(sort:)
    else
      state
    end
  end

  def self.sort(state)
    state => { cards: }

    char = input.getch

    case char
    when "f"
      sort = Subsequent::Sort::First
      format_state(cards:, sort:)
    when "m"
      sort = Subsequent::Sort::MostUncheckedItems
      format_state(cards:, sort:)
    when "l"
      sort = Subsequent::Sort::LeastUncheckedItems
      format_state(cards:, sort:)
    when "q", "\u0004", "\u0003"
      State.new(**state.to_h, mode: :normal)
    else
      state
    end
  end

  def self.open_links(state)
    state => { card:, checklist_items: }

    links =
      if checklist_items.present?
        checklist_items.flat_map(&:links)
      else
        [card.short_url]
      end

    links.each do |link|
      system("open", link)

      # otherwise system can open links in inconsistent order
      sleep(0.1)
    end

    state
  end

  def self.archive_card(state)
    state => { card:, sort: }

    output.print("#{red("Archive this card?")} (y/n) ")
    char = input.getch

    if char == "y"
      Subsequent::TrelloClient.update_card(card, closed: true)
      fetch_data(sort:)
    else
      state
    end
  end
end
