# frozen_string_literal: true

class Game
  attr_reader :board, :players

  def initialize(board, current_player, other_player)
    @board = board

    @players = [current_player, other_player]

    players.find { _1.instance_of?(ComputerPlayer) }&.game = self
  end

  def start
    loop do
      board.display

      pick = players.first.pick

      next puts 'Invalid pick' unless board.valid_pick?(pick)

      color, col, row = board.drop_disc(pick, players.first.color)
      break over(players.first) if over?(color, col, row)

      players.rotate!
    end
  end

  def over?(color, col, row) = win?(color, col, row) || board.filled?

  def win?(color, col, row)
    (-1..1).any? do |k|
      l = ((1..3).find { |i| board.at(col - i, row - k * i) != color } || 4) - 1
      r = ((1..3).find { |i| board.at(col + i, row + k * i) != color } || 4) - 1
      l + r >= 3
    end || vertical_win?(color, col, row)
  end

  def over(winner)
    board.display
    puts "#{winner.name} has won!"
  end

  private

  def vertical_win?(color, col, row)
    ((1..3).find { |i| board.at(col, row - i) != color } || 4) - 1 >= 3
  end
end
