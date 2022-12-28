# frozen_string_literal: true

require_relative '../player/human_player/human_player'
require_relative '../player/computer_player/computer_player'
require_relative '../game_setup/game_setup'
require_relative '../game/game'
require_relative '../board/board'

module ConnectFour
  PROMPT = TTY::Prompt.new
end
