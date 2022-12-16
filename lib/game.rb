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

  def horizontal_win?(color)
    6.times do |i|
      color_counter = 0
      @board.cols.each do |col|
        col[i] == color ? color_counter += 1 : color_counter = 0
        return true if color_counter == 4
      end
    end
    false
  end

  def vertical_win?(color)
    @board.cols.each do |col|
      color_counter = 0
      col.each do |cell|
        break unless cell

        cell == color ? color_counter += 1 : color_counter = 0
        return true if color_counter == 4
      end
    end
    false
  end
end