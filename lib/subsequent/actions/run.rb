module Subsequent::Actions::Run

  extend Subsequent::Colors

  def self.call
    loop do
      system("clear")

      card = Subsequent::TrelloClient.fetch_next_card
      checklist = card.checklists.find(&:unchecked_items?)
      if checklist
        checklist.unchecked_items.first(5).each_with_index do |item, index|
          puts "#{index + 1}. ☐ #{green(item.name)}"
        end
      else
        puts "No unchecked items, finish card: #{card.name}"
      end

      puts
      puts commands

      handle_input(checklist)
    end
  end

  def self.commands
    [
      "Press a number to complete task",
      "#{cyan("q")} to quit",
      "#{cyan("r")} to refresh",
    ]
  end

  def self.handle_input(checklist)
    input = $stdin.getch

    if input == "q" || input == "\u0004" || input == "\u0003"
      puts yellow("Goodbye!")
      exit
    elsif input == "r"
      return
    else
      task_number = Integer(input)
      if task_number < 1 || task_number > checklist.unchecked_items.size
        raise ArgumentError
      end

      item = checklist.unchecked_items[input.to_i - 1]

      puts "Complete task? (y/n) #{item.name}"
      input = $stdin.getch
      puts input
      if input == "y"
        Subsequent::TrelloClient.complete_checklist_item(item)
      end
    end
  rescue ArgumentError
    retry
  end
end
