# frozen_string_literal: true

require_relative 'player/human_player/human_player'
require_relative 'player/computer_player/computer_player'
require_relative 'game/game'
require_relative 'board/board'

board = ConnectFour::Board.new

human_player = ConnectFour::HumanPlayer.new
computer_player = ConnectFour::ComputerPlayer.new(board, difficulty: 4)

game = ConnectFour::Game.new(board, human_player, computer_player)

game.play
