# frozen_string_literal: true

class Game
  attr_reader :board

  def initialize(board)
    @board = board
    # @player_1 = player_1
    # @player_2 = player_2
  end

  def over?(color, col, row)
    vertical_win?(color, col, row) || horizontal_win?(color, col, row) || diagonal_win?(color, col, row) || @board.filled?
  end

  private

  def win?(color, col, row, k)
    l = (1..3).find { |i| board.cols.dig(col - i, row - k * i) != color } || 4
    r = (1..3).find { |i| board.cols.dig(col + i, row + k * i) != color } || 4
    l + r >= 3
  end

  def diagonal_win?(color, col, row)
    forward_diagonal_win?(color, col, row) || backward_diagonal_win?(color, col, row)
  end

  def forward_diagonal_win?(color, col, row) = win?(color, col, row, 1)

  def backward_diagonal_win?(color, col, row) = win?(color, col, row, -1)

  def horizontal_win?(color, col, row) = win?(color, col, row, 0)

  def vertical_win?(color, col, row)
    top = (1..3).find { |i| board.cols.dig(col, row + i) != color } || 4
    bottom = (1..3).find { |i| board.cols.dig(col, row - i) != color } || 4
    top + bottom >= 3
  end
end
