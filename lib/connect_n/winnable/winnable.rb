# frozen_string_literal: true

module ConnectN
  module Winnable
    def win?(board, row_num, col_num, disc)
      return true if vertical_win?(board, row_num, col_num, disc)

      # k = -1 => backward diagonal \
      # k = 0 => horizontal --
      # k = 1 => forward diagonal /
      (-1..1).any? do |k|
        l = l_discs(board, row_num, col_num, disc, k)
        r = r_discs(board, row_num, col_num, disc, k)
        l + r + 1 >= min_to_win
      end
    end

    private

    def vertical_win?(board, row_num, col_num, disc)
      v = v_discs(board, row_num, col_num, disc)
      v + 1 >= min_to_win
    end

    # Count similar discs on the left side
    def l_discs(board, row_num, col_num, disc, k)
      range = (1...min_to_win)
      amount = range.find { |i| board.cell(row_num - k * i, col_num - i) != disc }

      # amount can be nil if there are more similar discs than min_to_win
      # in which case it should count as a win
      amount ||= min_to_win

      # Subtract the dropped disc
      amount -= 1
    end

    # Count similar discs on the right side
    def r_discs(board, row_num, col_num, disc, k)
      range = (1...min_to_win)
      amount = range.find { |i| board.cell(row_num + k * i, col_num + i) != disc }

      # amount can be nil if there are more similar discs than min_to_win
      # in which case it should count as a win
      amount ||= min_to_win

      # Subtract the dropped disc
      amount -= 1
    end

    # Count similar discs forming a vertical line
    def v_discs(board, row_num, col_num, disc)
      range = (1...min_to_win)
      amount = range.find do |i|
        board.cell(row_num - i, col_num) != disc
      end

      # amount can be nil if there are more similar discs than min_to_win
      # in which case it should count as a win
      amount ||= min_to_win
      
      # Subtract the dropped disc
      amount -= 1
    end
  end
end
