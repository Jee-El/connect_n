# frozen_string_literal: true

require 'tty-prompt'
require 'tty-box'

require_relative '../winnable/winnable'
require_relative '../displayable/displayable'

module ConnectFour
  class Game
    include Displayable
    include Winnable

    attr_reader :board, :players

    def initialize(board, current_player, other_player)
      @board = board
      @players = [current_player, other_player]
    end

    def play
      welcome(board)
      loop do
        current_player = players.first

        pick = current_player.pick

        next invalid_pick unless board.valid_pick?(pick)

        row, col, disc = board.drop_disc(current_player.disc, at_col: pick)

        clear_display
        board.display

        break over(current_player) if over?(board, row, col, disc)

        players.rotate!
      end
    end

    def over?(board, row, col, disc)
      win?(board, row, col, disc) || board.filled?
    end

    def play_again?
      PROMPT.yes? 'Would you like to play again?'
    end
  end
end
