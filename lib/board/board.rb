# frozen_string_literal: true

module ConnectFour
  class Board
    attr_reader :cols, :empty_disc

    def initialize(cols_amount: 7, rows_amount: 6, empty_disc: '⚪')
      @cols = Array.new(cols_amount) { Array.new(rows_amount) { empty_disc } }
      @empty_disc = empty_disc
    end
  
    def initialize_copy(original_board)
      super
      @cols = @cols.dup.map &:dup
    end
  
    def drop_disc(pick, disc)
      row = cols[pick].index(empty_disc)
      return unless row
  
      cols[pick][row] = disc
      [disc, pick, row]
    end
  
    def valid_pick?(pick)
      pick.between?(0, @cols.length - 1) && cols[pick].include?(empty_disc)
    end
  
    def filled?
      !cols.flatten.index(empty_disc)
    end
  
    def display
      cols.transpose.reverse_each { |row| puts row.join }
    end
  
    def at(col, row)
      return if [col, row].any?(&:negative?)
  
      cols.dig(col, row)
    end
  end
end

