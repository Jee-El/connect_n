# frozen_string_literal: true

require_relative '../player/human_player/human_player'
require_relative '../player/computer_player/computer_player'
require_relative '../game/game'
require_relative '../board/board'

module ConnectFour
  class GameSetup
    attr_reader :parameters, :game

    def initialize
      @parameters = { human_players: [] }
    end

    def setup_parameters
      parameters[:human_players].push [human_name, disc]

      parameters[:mode] = mode

      if parameters[:mode] == 'multiplayer'
        parameters[:human_players].push [human_name => disc]
      else
        parameters[:difficulty] = difficulty
        parameters[:human_starts?] = human_starts?
      end
    end

    def launch_game
      if Game.resume?
        game_name = Game.saved_game_name
        game = Game.load game_name
        return Game.resume game
      end

      @game = if parameters[:mode] == 'multiplayer'
                multiplayer_game
              else
                single_player_game
              end
      game.play
    end

    private

    def difficulty
      PROMPT.slider 'Difficulty : ', [*0..10], default: 0
    end

    def mode
      PROMPT.select('Choose a game mode : ', ['Single Player', 'Multiplayer']).downcase
    end

    def human_starts?
      PROMPT.yes? 'Do you wanna play first?'
    end

    def disc
      PROMPT.ask 'Enter a character that will represent your disc (optional) : ' do |q|
        q.validate(/^.?$/)
        q.messages[:valid?] = 'Please enter a single character.'
      end
    end

    def human_name
      PROMPT.ask 'Enter your name (optional) : ', default: ENV['USER']
    end

    def multiplayer_game
      human_players = multiplayer_players
      ConnectFour::Game.new(Board.new, *players)
    end

    def single_player_game
      board = Board.new
      players = single_player_players(board)
      ConnectFour::Game.new(board, *players)
    end

    def multiplayer_players
      parameters[:human_players].map do |name, disc|
        next ConnectFour::HumanPlayer.new(name: name, disc: disc) if disc

        ConnectFour::HumanPlayer.new(name: name)
      end
    end

    def single_player_players(board)
      name, disc = parameters[:human_players].first
      players = [
        if disc
          ConnectFour::HumanPlayer.new name: name, disc: disc
        else
          ConnectFour::HumanPlayer.new name: name
        end,
        ConnectFour::ComputerPlayer.new(board, difficulty: parameters[:difficulty])
      ]
      parameters[:human_starts?] ? players : players.rotate
    end
  end
end
