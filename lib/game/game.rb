# frozen_string_literal: true

require_relative '../winnable/winnable'

module ConnectFour
  class Game
    include Winnable
  
    attr_reader :board, :players
  
    def initialize(board, current_player, other_player)
      @board = board
      @players = [current_player, other_player]
    end
  
    def play
      board.display
      loop do
        current_player = players.first
  
        pick = current_player.pick
  
        next puts 'Invalid Pick' unless board.valid_pick?(pick)
  
        disc, col, row = board.drop_disc(pick, current_player.disc)
  
        clear_screen
        board.display
  
        break over(current_player) if over?(board, disc, col, row)
  
        players.rotate!
      end
    end
  
    def over?(board, disc = :nil, col = -Float::INFINITY, row = -Float::INFINITY)
      win?(board, disc, col, row) || board.filled?
    end
  
    def over(winner) = puts "#{winner.name} has won!"

    def play_again?
      until [0, 1].include?(input = gets.to_i); end
      input == 1
    end
  
    private
  
    def clear_screen
      puts "\e[1;1H\e[2J"
    end
  end
end
