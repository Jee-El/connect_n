# connect_n gem

# Installation

Add this line to your application's Gemfile :

`gem 'connect_n'`

Then run :

`bundle`

Or install it directly by running :

`gem install connect_n`

# Contents

- [What I learnt](#what-i-learnt)

- [ComputerPlayer's mechanism](#computerplayer-mechanism)

- [Documentation](#documentation)

  - [Board](#board)

    - [#cell_at](#cell_at)

    - [#col_at](#col_at)

    - [#cols](#cols)

    - [#draw](#draw)

    - [#drop_disc](#drop_disc)

    - [#filled?](#filled?)

    - [#initialize](#initialize)

    - [#row](#row)

    - [#rows](#rows)

    - [#valid_pick?](#valid_pick?)

  - [Demo](#demo)

    - [#launch](#launch)

  - [Game](#game)

    - [::games](#games)

    - [::game_name](#game_name)

    - [::list_games](#list_games)

    - [::load](#load)

    - [::save](#save)

    - [::save?](#save?)

    - [::resume](#resume)

    - [::resume?](#resume?)

    - [#clear_display](#clear_display)

    - [#initialize](#initialize-1)

    - [#invalid_pick](#invalid_pick)

    - [#play](#play)

    - [#play_again?](#play_again?)

    - [#over](#over)

    - [#over?](#over?)

    - [#welcome](#welcome)

  - [Player](#player)

    - [#initialize](#initialize-2)

  - [HumanPlayer](#humanplayer)

    - [#initialize](#initialize-3)

    - [#pick](#pick)

  - [ComputerPlayer](#computerplayer)

    - [#initialize](#initialize-4)

    - [#pick](#pick-1)

  - [Winnable](#winnable)

    - [#win?](#win?)

## What I learnt

- How to test my project with RSpec.

- How starting a project by writing tests first helps organize the project.

## ComputerPlayer's mechanism

It is made of a combination of minimax algorithm, alpha-beta pruning, and the heuristic function that is explained here : https://identity.pub/2019/10/16/minimax-connect4.html

## Documentation

### Board

#### cell_at

`board.cell_at(row_num, col_num) -> object or nil`

Returns the board cell at coordinates (row_num, col_num), `self` is not modified.

If `row_num` (or resp. `col_num`) is not an `Integer` in the range `0..rows_amount-1` (or resp. `0..cols_amount-1`), returns `nil`.

**_Notes_** :

- The 1st cell, at (0, 0), is the one in the bottom left corner.

```ruby
board = ConnectN::Board.new
bottom_left_corner_cell = board.cell_at(0, 0) #=> '⚪'
```

#### col_at

`board.col_at(n) -> Array or nil`

Returns the board's `nth` column, `self` is not modified.

If `n` is not an `Integer` in the range `0..cols_amount-1`, returns `nil`.

**_Notes_** :

- The 1st column, at (0), is the one on the far left.

- The column elements are ordered bottom-to-top.

```ruby
board = ConnectN::Board.new
far_left_col = board.col_at(0) #=> ['⚪', '⚪', '⚪', '⚪', '⚪', '⚪']
```

### cols

`board.cols -> 2D Array`

Returns the board's columns, `self` is not modified.

**_Notes_** :

- The 1st column is the one on the far left.

- Each column's elements are ordered bottom-to-top.

```ruby
board = ConnectN::Board.new
cols = board.cols
```

### draw

`board.draw -> nil`

Returns `nil`.

Outputs the board in a table-format to stdout.

```ruby
board = ConnectN::Board.new
board.draw
```

### drop_disc

`board.drop_disc(disc, at_col:) -> Array`

Modifies `self` by dropping `disc` at the board's column number `at_col`.

Returns an array of length 3 `[row_num, col_num, disc]`.

The 1st 2 elements represent the coordinates of the cell at which the disc was dropped, the third element is the dropped disc.

**_Notes_** :

- If the given `at_col` refers to a filled column, an exception is raised.

```ruby
board = ConnectN::Board.new
board.drop_disc('🔥', at_col: 0) #=> [0, 0, '🔥']
```

### filled?

`board.filled? -> true or false`

Returns true if the board is filled, returns false otherwise.

```ruby
board = ConnectN::Board.new
board.filled? #=> false
```

### initialize

`Board.new(rows_amount: 6, cols_amount: 7, empty_disc: '⚪' -> Board`

Returns a `Board` instance with the dimensions `rows_amount x cols_amount`, with each cell containing the value of `empty_disc`.

**_Notes_** :

- `rows_amount` & `cols_amount` must be a `Float` or `Integer` >= 0

- `empty_disc` can be any object.

```ruby
default_board = ConnectN::Board.new #=> 6x7 board
board = ConnectN::Board.new rows_amount: 9, cols_amount: 9 #=> 9x9 board
```

#### row_at

`board.row_at(n) -> Array or nil`

Returns the board's `nth` row, `self` is not modified.

If `n` is not in the range `0..cols_amount-1`, returns `nil`.

**_Notes_** :

- The 1st row, at (0), is the one in the bottom of the board.

- The row elements are ordered left-to-right.

```ruby
board = ConnectN::Board.new
bottom_row = board.row_at(0) #=> ['⚪', '⚪', '⚪', '⚪', '⚪', '⚪', '⚪']
```

### rows

`board.rows -> 2D Array`

Returns the board's rows, `self` is not modified.

**_Notes_** :

- The 1st row is the one in the bottom of the board.

- Each row's elements are ordered left-to-right.

```ruby
board = ConnectN::Board.new
rows = board.rows
```

### valid_pick?

`board.valid_pick?(pick) -> true or false`

Returns `true` if `pick` is a valid column number, i.e the column is not filled nor outside of the range `0..cols_amount-1`. `self` is not modified.

```ruby
board = ConnectN::Board.new
board.valid_pick?(3) #=> true
```

## Demo

**_Notes_** :

- `Demo`'s purpose is to show all features of the gem and to give you an idea on how you could use it to build your own custom connect_n game.

### launch

`demo.launch -> `

Runs a game demo.

```ruby
demo = ConnectN::Demo.new
demo.launch
```
