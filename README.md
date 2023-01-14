# connect_n gem

Online Demo : https://replit.com/@Jee-El/connectn?v=1

# Installation

Add this line to your application's Gemfile :

```ruby
gem 'connect_n'
```

Then run :

```
bundle
```

Or install it directly by running :

```
gem install connect_n
```

# Contents

- [1. What I learnt](#1-what-i-learnt)
- [2. Contributing](#2-contributing)
- [3. ComputerPlayer's mechanism](#3-computerplayers-mechanism)
- [4. Documentation](#4-documentation)
  - [4.1 Board](#41-board)
    - [4.1.1 ::new](#417-new)
    - [4.1.2 #cell_at](#411cell_at)
    - [4.1.3 #col_at](#412col_at)
    - [4.1.4 #cols](#413-cols)
    - [4.1.5 #draw](#414-draw)
    - [4.1.6 #drop_disc](#415-drop_disc)
    - [4.1.7 #filled?](#416-filled?)
    - [4.1.8 #row](#418-row)
    - [4.1.9 #rows](#419-rows)
    - [4.1.10 #valid_pick?](#4110valid_pick?)
  - [4.2 Demo](#42-demo)
    - [4.2.1 ::new](#421-new)
    - [4.2.2 #launch](#421-launch)
  - [4.3 Game](#43-game)
    - [4.3.1 ::games](#431-games)
    - [4.3.2 ::select_game_name](#432-select_game_name)
    - [4.3.3 ::load](#433-load)
    - [4.3.4 ::new](#434-new)
    - [4.3.5 ::resume](#435-resume)
    - [4.3.6 ::resume?](#436-resume?)
    - [4.3.7 ::save](#437-save)
    - [4.3.8 ::save?](#438-save?)
    - [4.3.9 #invalid_pick](#439-invalid_pick)
    - [4.3.10 #play](#4310-play)
    - [4.3.11 #play_again?](#4311-play_again?)
    - [4.3.12 #over](#4312-over)
    - [4.3.13 #over?](#4313-over?)
    - [4.3.14 #welcome](#4314-welcome)
  - [4.4 Player](#44-player)
    - [4.4.1 ::new](#441-initialize)
  - [4.5 HumanPlayer](#45-humanplayer)
    - [4.5.1 ::new](#451-initialize-3)
    - [4.5.2 #pick](#452-pick)
  - [4.6 ComputerPlayer](#46-computerplayer)
    - [4.6.1 ::new](#461-initialize)
    - [4.6.2 #pick](#462-pick)
  - [4.7 Prompt](#47-prompt)
    - [4.7.1 ::ask_for_cols_amount](#471-ask_for_cols_amount)
    - [4.7.2 ::ask_for_difficulty](#472-ask_for_difficuly)
    - [4.7.3 ::ask_for_disc](#473-ask_for_disc)
    - [4.7.4 ::ask_for_min_to_win](#474-ask_for_min_to_win)
    - [4.7.5 ::ask_for_mode](#475-ask_for_mode)
    - [4.7.6 ::ask_for_name](#476-ask_for_name)
    - [4.7.7 ::ask_for_pick](#477-ask_for_pick)
    - [4.7.8 ::ask_for_rows_amount][#478-ask_for_rows_amount]
    - [4.7.9 ::starts?](#479-human_starts?)
  - [4.8 Winnable](#47-winnable)
    - [4.8.1 #win?](#471-win?)

# 1. What I learnt

- How to test my project with RSpec.

- How starting a project by writing tests first helps organize the project.

# 2. Contributing

**Contributions of any kind are more than welcome!**

Feel free to open a github issue or a pull request if you come across any typos or bugs, or if you find some parts of the API confusing, or if you would like to suggest a new feature :D!

# 3. ComputerPlayer's mechanism

It is made of a combination of minimax algorithm, alpha-beta pruning, and the heuristic function that is explained here : https://identity.pub/2019/10/16/minimax-connect4.html

# 4. Documentation

## 4.1 Board

## 4.1.1 ::new

```ruby
ConnectN::Board.new(rows_amount: 6, cols_amount: 7, empty_disc: '⚪' -> ConnectN::Board
```

Returns a `Board` instance with the dimensions `rows_amount x cols_amount`, with each cell containing the value of `empty_disc`.

**_Notes_** :

- `rows_amount` & `cols_amount` must be a `Float`/`Integer` >= 0

- `empty_disc` can be any object.

```ruby
default_board = ConnectN::Board.new #=> 6x7 board
board = ConnectN::Board.new rows_amount: 9, cols_amount: 9 #=> 9x9 board
```

### 4.1.2 #cell_at

```ruby
board.cell_at(row_num, col_num) -> object or nil
```

Returns the board cell at coordinates (row_num, col_num).

If `row_num` (or resp. `col_num`) is not in the range `0..rows_amount-1` (or resp. `0..cols_amount-1`), returns `nil`.

**_Notes_** :

- The 1st cell, at (0, 0), is the one in the bottom left corner.

```ruby
board = ConnectN::Board.new
bottom_left_corner_cell = board.cell_at(0, 0) #=> '⚪'
```

### 4.1.3 #col_at

```ruby
board.col_at(n) -> Array or nil
```

Returns the board's `nth` column.

If `n` is not in the range `0..cols_amount-1`, returns `nil`.

**_Notes_** :

- The 1st column, at (0), is the one on the far left.

- The column elements are ordered bottom-to-top.

```ruby
board = ConnectN::Board.new
far_left_col = board.col_at(0) #=> ['⚪', '⚪', '⚪', '⚪', '⚪', '⚪']
```

## 4.1.4 #cols

```ruby
board.cols -> 2D Array
```

Returns the board's columns.

**_Notes_** :

- The 1st column is the one on the far left.

- Each column's elements are ordered bottom-to-top.

```ruby
board = ConnectN::Board.new
cols = board.cols
```

## 4.1.5 #draw

```ruby
board.draw -> nil
```

Outputs the board in a table-format to stdout and returns `nil`.

```ruby
board = ConnectN::Board.new
board.draw
```

## 4.1.6 #drop_disc

```ruby
board.drop_disc(disc, at_col:) -> Array
```

Modifies `self` by dropping `disc` at the board's column number `at_col`.

Returns an array of length 3 `[row_num, col_num, disc]`.

The 1st 2 elements represent the coordinates of the cell at which the disc was dropped, the third element is the dropped disc.

`disc` can by any object.

`at_col` must be in the range `0..cols_amount-1`.

**_Notes_** :

- If the given `at_col` refers to a filled column, an exception is raised.

```ruby
board = ConnectN::Board.new
board.drop_disc('🔥', at_col: 0) #=> [0, 0, '🔥']
```

## 4.1.7 #filled?

```ruby
board.filled? -> true or false
```

Returns true if the board is filled, returns false otherwise.

```ruby
board = ConnectN::Board.new
board.filled? #=> false
```

### 4.1.8 #row_at

```ruby
board.row_at(n) -> Array or nil
```

Returns the board's `nth` row.

If `n` is not in the range `0..cols_amount-1`, returns `nil`.

**_Notes_** :

- The 1st row, at (0), is the one in the bottom of the board.

- The row elements are ordered left-to-right.

```ruby
board = ConnectN::Board.new
bottom_row = board.row_at(0) #=> ['⚪', '⚪', '⚪', '⚪', '⚪', '⚪', '⚪']
```

## 4.1.9 #rows

```ruby
board.rows -> 2D Array
```

Returns the board's rows, `self` is not modified.

**_Notes_** :

- The 1st row is the one in the bottom of the board.

- Each row's elements are ordered left-to-right.

```ruby
board = ConnectN::Board.new
rows = board.rows
```

## 4.1.10 #valid_pick?

```ruby
board.valid_pick?(pick) -> true or false
```

Returns `true` if `pick` is a valid column number, i.e the column is not filled nor outside of the range `0..cols_amount-1`. `self` is not modified.

```ruby
board = ConnectN::Board.new
board.valid_pick?(3) #=> true
```

# 4.2 Demo

**_Notes_** :

- `Demo`'s purpose is to show all features of the gem and to give you an idea on how you could use it to build your own custom connect_n game.

- You need to create a yaml file called `connect_n_saved_games.yaml` in the directory where you run `Demo#launch`.

## 4.2.1 ::new

```ruby
ConnectN::Demo.new -> ConnectN::Demo
```

## 4.2.2 #launch

```ruby
demo.launch(yaml_fn) -> nil
```

Runs a game demo.

**_Notes_** :

- `yaml_fn` must exist and be a yaml file.

```ruby
demo = ConnectN::Demo.new
demo.launch('saved_games.yaml)
```

# 4.3 Game

## 4.3.1 ::games

```ruby
ConnectN::Game.games(yaml_fn) -> Hash
```

Returns a deserialized hash from the given `yaml_fn` whose keys are symbols representing the names of the saved games, while values are the corresponding game instances.

**_Notes_** :

- `yaml_fn` must be a YAML file.

```ruby
ConnectN::Game.games('empty.yaml') #=> {}
ConnectN::Game.games('not_empty.yaml') #=> { test: game_obj }
```

## 4.3.2 ::select_game_name

```ruby
ConnectN::Game.select_game_name(yaml_fn) -> Symbol
```

Lists the games saved in `yaml_fn` for the user to select one & returns the selected game name as a symbol.

**_Notes_** :

- `yaml_fn` must contain at least one saved game, otherwise an exception is raised.

```ruby
ConnectN::Game.select_game_name('empty.yaml') # Exception is raised
ConnectN::Game.select_game_name('not_empty.yaml') #=> works as intended
```

## 4.3.3 ::load

```ruby
ConnectN::Game.load(name, yaml_fn) -> ConnectN::Game or nil
```

Returns the `ConnectN::Game` instance named `name` in `yaml_fn`.

Returns nil if no such game exists.

**_Notes_** :

- `name` must be a String or Symbol

```ruby
ConnectN::Game.load('test', 'my_games.yaml')
ConnectN::Game.load(:test, 'my_games.yaml')
```

## 4.3.4 ::new

```ruby
ConnectN::Game.new(board:, first_player:, second_player:, min_to_win:) -> ConnectN::Game
```

**_Notes_** :

- `board` must be a `ConnectN::Board` instance.

- `first_player` & `second_player` can be instances of `Player`, `HumanPlayer`, or `ComputerPlayer`.

- `min_to_win` is the minimum number of connected similar discs to count as a win. Must be a positive `Integer`.

```ruby
board = ConnectN::Board.new

player_1 = ConnectN::HumanPlayer.new(disc: 'A')
player_2 = ConnectN::HumanPlayer.new(disc: 'B')

game = ConnectN::Game.new(
  board: board,
  first_player: player_1,
  second_player: player_2,
)
```

## 4.3.5 ::resume

```ruby
ConnectN::Game.resume(game) -> nil
```

Resumes the given `game` and returns `nil`.

## 4.3.6 ::resume?

```ruby
ConnectN::Game.resume? -> true or false
```

Returns `true` if the user wants to resume a saved game.

Returns `false` otherwise.

## 4.3.7 ::save

```ruby
ConnectN::Game.save(game, name, yaml_fn) -> Integer
```

Serializes the given `game` as a `Hash` of key `name` & value `game` to the given `yaml_fn`.

**_Notes_** :

- `game` : `ConnectN::Game` instance.

- `name` : `String` or `Symbol`

## 4.3.8 ::save?

```ruby
ConnectN::Game.save? -> true or false
```

Returns `true` if the user wants to save the game.

Returns `false` otherwise.

## 4.3.9 #invalid_pick

```ruby
game.invalid_pick -> nil
```

Outputs the error message 'Invalid Column Number' on a red box to stdout.

## 4.3.10 #play

```ruby
game.play(yaml_fn = nil) -> nil
```

Starts the game.

Pass `yaml_fn` if you intend to save the game in the middle of playing it.

```ruby
board = ConnectN::Board.new

first_player = ConnectN::HumanPlayer.new
second_player = ConnectN::HumanPlayer.new

game = ConnectN::Game.new(
  board: board,
  first_player: first_player,
  second_player: second_player,
)
game.play('my_games.yaml')
```

## 4.3.11 #play_again?

```ruby
game.play_again? -> true or false
```

Returns `true` if the user wants to play the game again.

Returns `false` otherwise.

## 4.3.12 #over

```ruby
game.over(winner) -> nil
```

Outputs the winner's name on a green box to stdout.

If there is no winner, it similarly announces a tie.

## 4.3.13 #over?

```ruby
game.over? -> true or false
```

Returns `true` if a player has won or if it is a draw.

Returns `false` otherwise.

## 4.3.14 #welcome

```ruby
game.welcome -> nil
```

Outputs, to stdout, a friendly message that explains the game to the user.

# 4.4 Player

## 4.4.1 ::new

```ruby
ConnectN::Player.new(name:, disc:) -> ConnectN::Player
```

Creates a `Player` instance with the name `name` and disc `disc`.

**_Notes_** :

- `name` can be any object, a `Symbol` or `String` makes more sense, though.

- `disc` can be any object, a `Symbol` or `String` makes more sense, though.

- Both `names` & `disc` can be reassigned after creation.

# 4.5 HumanPlayer

## 4.5.1 ::new

```ruby
ConnectN::HumanPlayer.new(name: 'Human', disc: '🔥', save_key: ':w') -> ConnectN::HumanPlayer
```

**_Notes_** :

- To understand the use of `save_key`, see [next section](#352-pick).

- `HumanPlayer` inherits from `ConnectN::Player`.

- The only difference between `Player::new` and `HumanPlayer::new` are the default values.

## 4.5.2 #pick

```ruby
human_player.pick -> Object
```

Prompts the user to enter a pick, i.e a column number.

If the value of `human_player.save_key` is entered by the user, it is recognized as the user wanting to save the game. For example, it is used in `Game#play`.

Returns the value of `human_player.save_key` if the user wants to save the game.

Returns the `Integer` entered by the user, minus one.

```ruby
human_player = ConnectN::HumanPlayer.new
# User enters ':w'
human_player.pick #=> :w

# User enters '5'
human_player.pick #=> 4

# User enters 'random string'
human_player.pick #=> -1

```

# 4.6 ComputerPlayer

## 4.6.1 ::new

```ruby
ConnectN::ComputerPlayer.new(
  name: 'Computer',
  disc: '🧊',
  min_to_win: 4,
  difficulty: 0,
  delay: 0,
  board:,
  opponent_disc:
) -> ConnectN::ComputerPlayer
```

- `min_to_win` : Must be the same `min_to_win` of the `ConnectN::Game` instance.

- `difficulty` : an `Integer` greater than or equal to 0. The higher it is, the harder it is to beat the computer.

- `delay` : a/an `Float`/`Integer` of how many seconds the `ConnectN::ComputerPlayer` instance should take to play its pick.

- `board` : Must be the same `ConnectN::Board` instance given to the `ConnectN::Game` instance.

- `opponent_disc` : Must be the `disc` of the opponent player.

```ruby

board = ConnectN::Board.new

player_1 = ConnectN::ComputerPlayer.new(
  difficulty: 4,
  delay: 2,
  board: board,
  opponent_disc: '🔥'
)
player_2 = ConnectN::ComputerPlayer.new(
  difficulty: 4,
  delay: 2,
  board: board,
  opponent_disc: player_1.disc
)

game = ConnectN::Game.new(
  board: board,
  first_player: player_1,
  second_player: player_2,
)

game.play
```

## 4.6.2 #pick

`computer_player.pick -> Integer`

Returns a valid column number, i.e in the range `0..cols_amount-1`.

See [this](2-computerplayers-mechanism) for more info on how it works.

# 4.7 Prompt

## 4.7.1 ::ask_for_cols_amount

```ruby
ConnectN::Prompt.ask_for_cols_amount(
  prompt: 'How many columns do you want in the board?',
  default: 7
) -> Integer
```

Prompts the user, with a prompt consisting of the value of `prompt`, to enter the amount of columns to be in the board.

`default`'s value is returned if the user does not enter any input and presses the enter key.

## 4.7.2 ::ask_for_difficulty

```ruby
ConnectN::Prompt.ask_for_difficulty(prompt: 'Difficulty : ', levels: [*0..10], default: 5) -> Integer
```

Prompts the user, with a prompt consisting of the value of `prompt`, followed by a slider that the user can slide to choose a difficulty level of the levels in `levels`.

`default` is the initial value of the slider.

## 4.7.3 ::ask_for_disc

```ruby
ConnectN::Prompt.ask_for_disc(
  prompt: 'Enter a character that will represent your disc : ',
  default: '🔥',
  error_msg: 'Please enter a single character.'
) -> String
```

Prompts the user, with a prompt consisting of the value of `prompt`, to enter the character that will represent their disc.

`default`'s value is returned if the user does not enter any input and presses the enter key.

`error_msg` is the error message displayed in case the user does not enter a single character.

## 4.7.4 ::ask_for_min_to_win

```ruby
ConnectN::Prompt.ask_for_min_to_win(
  prompt: 'Minimum number of aligned similar discs necessary to win : ',
  default: 4
) -> Integer
```

Prompts the user, with a prompt consisting of the value of `prompt`, to enter the minimum amount of aligned discs that will count as a win.

`default`'s value is returned if the user does not enter any input and presses the enter key.

## 4.7.5 ::ask_for_mode

```ruby
ConnectN::Prompt.ask_for_mode(prompt: 'Choose a game mode : ')
```

Prompts the user with a prompt consisting of the value of `prompt`, followed by a select menu that has two options :

- Single Player

- Multiplayer

## 4.7.6 ::ask_for_name

```ruby
ConnectN::Prompt.ask_for_name(prompt: 'Enter your name : ', default: ENV['USER']) -> String
```

Prompts the user with a prompt consisting of the value of `prompt`.

`default`'s value is returned if the user presses enter without entering anything.

## 4.7.7 ::ask_for_pick

```ruby
ConnectN::Prompt.ask_for_pick(prompt: 'Please enter a column number : ') -> String
```

Prompts the user with a prompt consisting of the value of `prompt`.

## 4.7.8 ::ask_for_rows_amount

```ruby
ConnectN::Prompt.ask_for_rows_amount(
  prompt: 'How many rows do you want in the board?',
  default: 6
) -> Integer
```

Same as `ConnectN::Prompt.ask_for_cols_amount` but with different default values.

## 4.7.9 ::starts?

```ruby
ConnectN::Prompt.starts?(prompt: 'Do you wanna play first?') -> true or false
```

Prompts the user with a yes/no prompt consisting of the value of `prompt`.

`true` is the default value returned if the user presses enter without entering anything.

# 4.8 Winnable

## 4.8.1 #win?

`win?(board, row_num, col_num, disc) -> true or false`

Returns true if `disc` getting dropped at the cell `(row_num, col_num)` of `board` makes a win.

Returns false otherwise.
