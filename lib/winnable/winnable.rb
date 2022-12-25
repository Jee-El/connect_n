# frozen_string_literal: true

module Winnable
  def win?(board, color, col, row)
    (-1..1).any? do |k|
      l = ((1..3).find { |i| board.at(col - i, row - k * i) != color } || 4) - 1
      r = ((1..3).find { |i| board.at(col + i, row + k * i) != color } || 4) - 1
      l + r >= 3
    end || vertical_win?(board, color, col, row)
  end

  private

  def vertical_win?(board, color, col, row)
    (((1..3).find { |i| board.at(col, row - i) != color } || 4) - 1) >= 3
  end
end
