# frozen_string_literal: true

%w[human_player computer_player game board].each { require_relative _1 }

board = Board.new

human_player = HumanPlayer.new
computer_player = ComputerPlayer.new(board, difficulty: 6)

game = Game.new(board, human_player, computer_player)

game.play
