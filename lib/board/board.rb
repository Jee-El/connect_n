# frozen_string_literal: true

module ConnectFour
  class Board
    attr_reader :table, :empty_disc, :cols_amount, :rows_amount

    def initialize(cols_amount: 7, rows_amount: 6, empty_disc: '⚪')
      @empty_disc = empty_disc

      @cols_amount = cols_amount

      @rows_amount = rows_amount

      @table = Array.new(rows_amount) { Array.new(cols_amount) { empty_disc } }
    end

    def initialize_copy(original_board)
      super
      @empty_disc = @empty_disc.clone
      @table = @table.clone.map(&:clone)
    end

    def drop_disc(disc, at_col:)
      i = col(at_col).index(empty_disc)
      row(i)[at_col] = disc
      [i, at_col, disc]
    end

    def valid_pick?(pick)
      valid_col?(pick) and col(pick).include?(empty_disc)
    end

    def filled?
      !table.flatten.include?(empty_disc)
    end

    def draw
      table.each{ |row| draw_border || draw_row(row) }
      draw_border
      draw_col_nums
    end

    def cell(i, j)
      return unless valid_cell?(i, j)

      row(i)[j]
    end

    def cols = table.transpose.map(&:reverse)

    def rows = table

    def col(j)
      return unless valid_col?(j)

      table.transpose[j].reverse
    end

    def row(i)
      return unless valid_row?(i)

      i = rows_amount - 1 - i
      table[i]
    end

    private

    def draw_border
      cols_amount.times { print '+----' } and puts '+'
    end

    def draw_row(row)
      puts '| ' + row.join(' | ') + ' |'
    end

    def draw_col_nums
      print '|'
      (1..cols_amount).each do |num|
        num.even? ? print(' ') : print('  ')
        print num
        num.odd? ? print(' ') : print('  |')
      end
      puts
    end

    def valid_cell?(i, j) = valid_row?(i) && valid_col?(j)

    def valid_row?(i) = i.between?(0, rows_amount - 1)
      
    def valid_col?(j) = j.between?(0, cols_amount - 1)
  end
end
