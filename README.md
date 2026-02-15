# Subsequent

A terminal-based CLI todo app that interfaces with Trello. Manage your cards,
checklists, and checklist items without leaving the terminal.

## Installation

```sh
gem install subsequent
```

Or add it to your Gemfile:

```ruby
gem "subsequent"
```

## Setup

Subsequent requires a Trello API key, token, and list ID. Create a config file
at `~/.subsequent/config.yml`:

```yaml
:trello_key: your-trello-api-key
:trello_token: your-trello-api-token
:trello_list_id: your-trello-list-id
```

To get your API key and token, visit the
[Trello Power-Ups admin](https://trello.com/power-ups/admin). To find your list
ID, open a Trello board in your browser, add `.json` to the URL, and search for
the list name.

## Usage

```sh
subsequent
```

Use `--debug` to disable the loading spinner:

```sh
subsequent --debug
```

### Keybindings

#### Normal mode (default)

| Key | Action |
|-----|--------|
| `1-9` | Toggle checklist item at that position |
| `r` | Refresh data from Trello |
| `f` | Enter filter mode |
| `s` | Enter sort mode |
| `o` | Open links in the current card |
| `c` | Enter cycle mode |
| `n` | Enter add item mode |
| `a` | Archive current card |
| `q` | Quit |

#### Filter mode

| Key | Action |
|-----|--------|
| `1-9` | Filter cards by the selected tag |
| `n` | Remove all filters |
| `q` | Cancel |

#### Sort mode

| Key | Action |
|-----|--------|
| `f` | Sort by first (original Trello order) |
| `m` | Sort by most unchecked items |
| `l` | Sort by least unchecked items |
| `q` | Cancel |

#### Cycle mode

| Key | Action |
|-----|--------|
| `c` | Move current card to end of list |
| `l` | Move current checklist to end within the card |
| `i` | Move current checklist item to end within the checklist |
| `q` | Cancel |

#### Add item mode

| Key | Action |
|-----|--------|
| `c` | Add a new card |
| `l` | Add a new checklist to the current card |
| `i` | Add a new checklist item to the current checklist |
| `q` | Cancel |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/mockdeep/subsequent.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
