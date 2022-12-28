# frozen_string_literal: true

require 'tty-table'

module ConnectFour
  class Board
    attr_reader :table, :empty_disc

    def initialize(cols_amount: 7, rows_amount: 6, empty_disc: '⚪')
      @empty_disc = empty_disc

      @headers = TTY::Table.new rows: [[*'1 '.."#{cols_amount} "]]

      @rows = Array.new(rows_amount) { Array.new(cols_amount) { empty_disc } }

      @table = TTY::Table.new rows: @rows
    end

    def initialize_copy(original_board)
      super
      @empty_disc = @empty_disc.clone
      @rows = @rows.clone.map(&:clone)

      @headers = Marshal.load Marshal.dump @headers
      @table = Marshal.load Marshal.dump @table
    end

    def drop_disc(disc, at_col:)
      row = table.column(at_col).index(empty_disc)
      return unless row

      update(row, at_col, disc)
    end

    def valid_pick?(pick)
      !!table.column(pick)&.include?(empty_disc)
    end

    def filled?
      !table.flatten.index(empty_disc)
    end

    def display
      # The table starts counting rows from top to bottom
      # And since all the other methods rely on rows starting
      # from bottom to top, it's easier to reverse the table rows
      # when displaying it than doing rows.length - index everywhere
      table.rows.reverse!
      puts table.render :ascii
      table.rows.reverse!
      puts @headers.render :ascii
    end

    def at(row, col)
      return if [row, col].any?(&:negative?) || !valid_pick?(col)

      table[row, col]
    end

    private

    def update(row, col, disc)
      @rows[row][col] = disc
      @table = TTY::Table.new rows: @rows
      [row, col, disc]
    end
  end
end
