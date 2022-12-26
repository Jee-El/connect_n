# frozen_string_literal: true

module ConnectFour
  module Winnable
    def win?(board, disc, col, row)
      (-1..1).any? do |k|
        l = ((1..3).find { |i| board.at(col - i, row - k * i) != disc } || 4) - 1
        r = ((1..3).find { |i| board.at(col + i, row + k * i) != disc } || 4) - 1
        l + r >= 3
      end || vertical_win?(board, disc, col, row)
    end
  
    private
  
    def vertical_win?(board, disc, col, row)
      (((1..3).find { |i| board.at(col, row - i) != disc } || 4) - 1) >= 3
    end
  end  
end
