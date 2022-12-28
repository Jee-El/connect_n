# frozen_string_literal: true

module ConnectFour
  module Winnable
    def win?(board, row, col, disc)
      (-1..1).any? do |k|
        l = ((1..3).find { |i| board.at(row - k * i, col - i) != disc } || 4) - 1
        r = ((1..3).find { |i| board.at(row + k * i, col + i) != disc } || 4) - 1
        l + r >= 3
      end || vertical_win?(board, row, col, disc)
    end

    private

    def vertical_win?(board, row, col, disc)
      (((1..3).find { |i| board.at(row - i, col) != disc } || 4) - 1) >= 3
    end
  end
end
