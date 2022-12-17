class Game
  attr_reader :board

  def initialize(board)
    @board = board
    # @player_1 = player_1
    # @player_2 = player_2
  end

  def over?(color)
    vertical_win?(color) || horizontal_win?(color) || diagonal_win?(color) || @board.filled?
  end

  private

  def diagonal_win?(color)
    forward_diagonal_win?(color) || backward_diagonal_win?(color)
  end

  def forward_diagonal_win?(color)

  end

  def backward_diagonal_win?(color)

  end

  def horizontal_win?(color)
    @board.cols.transpose.any? { |row| row.join.match? /(#{color}){4}/ }
  end

  def vertical_win?(color)
    @board.cols.any? { |col| col.join.match? /(#{color}){4}/ }
  end
end