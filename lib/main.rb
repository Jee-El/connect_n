# frozen_string_literal: true

require_relative 'connect_four/connect_four'
require_relative 'player/human_player/human_player'
require_relative 'player/computer_player/computer_player'
require_relative 'game_setup/game_setup'
require_relative 'game/game'
require_relative 'board/board'

game_setup = ConnectFour::GameSetup.new
game_setup.launch_game
