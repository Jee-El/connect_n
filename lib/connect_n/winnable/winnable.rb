# frozen_string_literal: true

module ConnectN
  module Winnable
    def win?(board, row, col, disc)
      (-1..1).any? do |k|
        l = ((1..3).find { |i| board.cell(row - k * i, col - i) != disc } || min_to_win) - 1
        r = ((1..3).find { |i| board.cell(row + k * i, col + i) != disc } || min_to_win) - 1
        l + r + 1 >= min_to_win
      end || vertical_win?(board, row, col, disc)
    end

    private

    def vertical_win?(board, row, col, disc)
      (((1..3).find { |i| board.cell(row - i, col) != disc } || min_to_win)) >= min_to_win
    end
  end
end
