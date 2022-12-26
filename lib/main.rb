# frozen_string_literal: true

require 'tty-box'

require_relative 'player/human_player/human_player'
require_relative 'player/computer_player/computer_player'
require_relative 'game/game'
require_relative 'board/board'

board = ConnectFour::Board.new(cols_amount: 9, rows_amount: 9)

human_player = ConnectFour::HumanPlayer.new
computer_player = ConnectFour::ComputerPlayer.new(board, difficulty: 4)

game = ConnectFour::Game.new(board, human_player, computer_player)

main_screen_text = <<-TEXT
  Welcome to Connect Four

  To play, Enter a number from 1
  to #{board.cols.length}
  The number corresponds to the
  column order starting from the
  left.
  Enter anything to proceed.
TEXT
puts TTY::Box.frame main_screen_text, padding: 2, align: :center
gets
puts "\e[1;1H\e[2J"

game.play
