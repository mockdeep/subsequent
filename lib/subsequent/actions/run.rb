module Subsequent::Actions::Run

  extend Subsequent::Colors

  DISPLAY_COUNT = 5
  SPINNER = [
    "▐⠂       ▌",
    "▐⠈       ▌",
    "▐ ⠂      ▌",
    "▐ ⠠      ▌",
    "▐  ⡀     ▌",
    "▐  ⠠     ▌",
    "▐   ⠂    ▌",
    "▐   ⠈    ▌",
    "▐    ⠂   ▌",
    "▐    ⠠   ▌",
    "▐     ⡀  ▌",
    "▐     ⠠  ▌",
    "▐      ⠂ ▌",
    "▐      ⠈ ▌",
    "▐       ⠂▌",
    "▐       ⠠▌",
    "▐       ⡀▌",
    "▐      ⠠ ▌",
    "▐      ⠂ ▌",
    "▐     ⠈  ▌",
    "▐     ⠂  ▌",
    "▐    ⠠   ▌",
    "▐    ⡀   ▌",
    "▐   ⠠    ▌",
    "▐   ⠂    ▌",
    "▐  ⠈     ▌",
    "▐  ⠂     ▌",
    "▐ ⠠      ▌",
    "▐ ⡀      ▌",
    "▐⠠       ▌"
  ].cycle

  def self.call
    fetch_data => { card:, checklist:, checklist_items: }

    loop do
      $stdout.clear_screen
      if checklist
        checklist_items.each_with_index do |item, index|
          icon = item.checked? ? "✔" : "☐"
          name = item.checked? ? gray(item.name) : green(item.name)
          puts "#{index + 1}. #{icon} #{name}"
        end
      else
        puts "No unchecked items, finish card: #{card.name}"
      end

      puts
      puts commands

      handle_input(card, checklist, checklist_items) => { card:, checklist:, checklist_items: }
    end
  end

  def self.commands
    [
      "Press a number to complete task",
      "#{cyan("q")} to quit",
      "#{cyan("r")} to refresh",
    ]
  end

  def self.fetch_data
    card = load_card
    checklist = card.checklists.find(&:unchecked_items?)
    checklist_items = checklist.unchecked_items.first(DISPLAY_COUNT)

    { card:, checklist:, checklist_items: }
  end

  def self.load_card
    thread = Thread.new { Subsequent::TrelloClient.fetch_next_card }

    while thread.alive?
      $stdout.clear_screen
      print SPINNER.next
      sleep 0.1
    end
    $stdout.clear_screen

    thread.value
  end

  def self.handle_input(card, checklist, checklist_items)
    input = $stdin.getch

    if input == "q" || input == "\u0004" || input == "\u0003"
      puts yellow("Goodbye!")
      exit
    elsif input == "r"
      fetch_data
    else
      task_number = Integer(input)
      raise ArgumentError if task_number < 1 || task_number > checklist_items.size

      item = checklist_items[input.to_i - 1]

      Subsequent::TrelloClient.toggle_checklist_item(item)

      { card:, checklist:, checklist_items: }
    end
  rescue ArgumentError
    retry
  end
end
