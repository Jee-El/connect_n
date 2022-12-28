# frozen_string_literal: true

require_relative 'connect_four/connect_four'

game_setup = ConnectFour::GameSetup.new
game_setup.setup_parameters
game_setup.launch_game
