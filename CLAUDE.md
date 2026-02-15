# Subsequent

A CLI todo app that interfaces with Trello, providing a TUI for managing
cards and checklists.

## Commands

- `bundle exec rake` - Run tests and linter (default task)
- `bundle exec rspec` - Run all tests
- `bundle exec rspec spec/subsequent/models/card_spec.rb` - Run a single test file
- `bundle exec rspec spec/subsequent/models/card_spec.rb:15` - Run a single example
- `bundle exec rubocop` - Run linter
- `bundle exec rubocop -a` - Run linter with auto-fix

## Architecture

- `lib/subsequent/models/` - Data models (Card, Checklist, ChecklistItem, Tag)
- `lib/subsequent/modes/` - UI modes (Normal, Filter, Sort, Cycle, AddCard, etc.)
- `lib/subsequent/commands/` - Trello API operations (FetchData, ArchiveCard, etc.)
- `lib/subsequent/options/` - Input handlers, self-registering via registry pattern
- `lib/subsequent/filters/` - Card filtering strategies (None, Tag)
- `lib/subsequent/sorts/` - Card sorting strategies (First, MostUnCheckedItems, etc.)
- `lib/subsequent/actions/` - App lifecycle (Run, Spin)
- `lib/subsequent/state.rb` - Immutable app state using `Data.define`
- `lib/subsequent/trello_client.rb` - Trello API HTTP client

## Code style

- Enforced by RuboCop with `EnabledByDefault: true`
- Double quotes for strings
- 80 character line limit
- Trailing commas in multiline arrays, hashes, and arguments
- `compact` style for class/module nesting (`class Subsequent::Foo`)
- Bracket syntax for symbol and word arrays (`[:foo]`, `["bar"]`)

## Testing

- RSpec with `expect` syntax only, no monkey patching
- 100% line and branch coverage required (SimpleCov)
- Tests run in random order
- WebMock disables all external HTTP requests
- Use `focus: true` to isolate tests during development
- Factories in `spec/support/factories.rb`
