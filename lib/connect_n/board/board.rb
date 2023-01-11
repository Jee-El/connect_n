# frozen_string_literal: true

module ConnectN
  class Board
    attr_reader :table, :empty_disc, :cols_amount, :rows_amount

    def initialize(rows_amount: 6, cols_amount: 7, empty_disc: '⚪')
      @empty_disc = empty_disc

      @rows_amount = rows_amount

      @cols_amount = cols_amount

      @table = Array.new(rows_amount) { Array.new(cols_amount) { empty_disc } }
    end

    def initialize_copy(original_board)
      super
      @empty_disc = @empty_disc.clone
      @table = @table.clone.map(&:clone)
    end

    def drop_disc(disc, at_col:)
      row_num = col_at(at_col).index(empty_disc)
      row_at(row_num)[at_col] = disc
      [row_num, at_col, disc]
    end

    def valid_pick?(pick)
      valid_col?(pick) and col_at(pick).include?(empty_disc)
    end

    def filled?
      !table.flatten.include?(empty_disc)
    end

    def draw
      table.each{ |row| draw_border || draw_row(row) }
      draw_border
      draw_col_nums
    end

    def cell_at(row_num, col_num)
      return unless valid_cell?(row_num, col_num)

      row_at(row_num)[col_num]
    end

    def cols
      table.transpose.map(&:reverse)
    end

    def rows
      table
    end

    def col_at(n)
      return unless valid_col?(n)

      table.transpose[n].reverse
    end

    def row_at(n)
      return unless valid_row?(n)

      n = rows_amount - 1 - n
      table[n]
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
        num.odd? ? print(' |') : print('  |')
      end
      puts
    end

    def valid_cell?(row_num, col_num)
      valid_row?(row_num) && valid_col?(col_num)
    end

    def valid_row?(n)
      n.between?(0, rows_amount - 1)
    end
      
    def valid_col?(n)
      n.between?(0, cols_amount - 1)
    end
  end
end
