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

    - [#cell](#cell)

    - [#col](#col)

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

  - [Displayable](#displayable)

    - [#clear_display](#clear_display)

    - [#invalid_pick](#invalid_pick)

    - [#over](#over)

    - [#welcome](#welcome)

  - [Game](#game)

    - [::games](#games)

    - [::game_name](#game_name)

    - [::list_games](#list_games)

    - [::load](#load)

    - [::save](#save)

    - [::save?](#save?)

    - [::resume](#resume)

    - [::resume?](#resume?)

    - [#initialize](#initialize-1)

    - [#play](#play)

    - [#play_again?](#play_again?)

    - [#over?](#over?)

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

#### cell

```ruby

# Syntax : board.cell(row_num, col_num)

# Argument data types : Integer, Integer

# Side effects : None

# Return :

  # If row_num & col_nums are, respectively, in the ranges 0..rows_amount-1 & 0..cols_amounts :

    # It returns the board cell at coordinates (row_num, cell_num)

  # Else :

    # It returns nil

# Notes :

  # The first cell is the bottom left corner one.

# Example :

board = Board.new
bottom_left_cell = board.cell(0, 0)
```

#### col

```ruby

# Syntax : board.col(col_num)

# Argument data type : Integer

# Side effects : None

# Return :

  # If col_num is in the range 0..cols_amount-1 :

    # It returns the col_numth of the board

  # Else :

    # It returns nil

# Notes :

  # The column elements are ordered bottom-to-top

  # The first column is the one on the far left.

# Example :

board = Board.new
far_left_col = board.col(0)

```

### cols

```ruby

# Syntax : board.cols

# Argument data type : None

# Side effects : None

# Return :

  # a 2D Array containing the board's columns

# Notes :

  # Each column's elements are ordered bottom-to-top

  # The first column is the one on the far left

# Example :

board = Board.new
cols = board.cols

```

### draw

```ruby

# Syntax : board.draw

# Argument data type : None

# Side effects : Outputs the board to stdout in a table-format

# Return :

  # nil

# Notes :

  # None

# Example :

board = Board.new
board.draw

```

### drop_disc

```ruby

# Syntax : board.drop_disc(disc, at_col:)

# Argument data type : Integer, at_col: Integer

# Side effects : Mutates the board so it contains the dropped disc at the column with the given number.

# Return :

  # An array [row_num, at_col, disc]

    # row_num -> the row number at which the disc was dropped

    # at_col the passed-in at_col value

    # disc is the passed-in disc value

# Notes :

  # The given at_col value must not match the number of a filled column, so validating the input with #valid_pick? first is recommended.

# Example :

board = Board.new
board.drop_disc('🔥', at_col: 0) #=> [0, 0, '🔥']

```

### filled?

```ruby

# Syntax : board.filled?

# Argument data type : None

# Side effects : None

# Return :

  # If the board is filled :

    # it returns true

  # Else :

    # it returns false

# Notes :

  # None

# Example :

board = Board.new
board.filled? #=> false

```

### initialize

```ruby

# Syntax : board.new(rows_amount: 6, cols_amount: 7, empty_disc: '⚪')

# Argument data type : rows_amount: Integer, cols_amount: Integer, empty_disc: Object

# Side effects : None

# Return :

  # Board instance

# Notes :

  # rows_amount >= 0

  # cols_amount >= 0

# Example :

default_board = Board.new #=> 6x7 board
board = Board.new rows_amount: 9, cols_amount: 9 #=> 9x9 board

```

#### row

```ruby

# Syntax : board.row(row_num)

# Argument data type : Integer

# Side effects : None

# Return :

  # If row_num is in the range 0..rows_amount-1 :

    # It returns the row_numth of the board

  # Else :

    # It returns nil

# Notes :

  # The column elements are ordered left-to-right

  # The first row is the one in the bottom.

# Example :

board = Board.new
bottom_row = board.row(0)

```

### rows

```ruby

# Syntax : board.rows

# Argument data type : None

# Side effects : None

# Return :

  # a 2D Array containing the board's rows

# Notes :

  # Each rows's elements are ordered left-to-right

  # The first row is the one in the bottom

# Example :

board = Board.new
rows = board.rows

```

### valid_pick?

```ruby

# Syntax : board.valid_pick?(pick)

# Argument data type : Integer

# Side effects : None

# Return :

  # If it is a valid pick :

    # it returns true

  # Else :

    # it returns false

# Notes :

  # A valid pick must be in the range 0..cols_amount-1,

  # And the column at the pick must not be filled

# Example :

board = Board.new
board.valid_pick?(3) #=> true

```
