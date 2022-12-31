# frozen_string_literal: true

require_relative '../player/human_player/human_player'
require_relative '../player/computer_player/computer_player'
require_relative '../game/game'
require_relative '../board/board'

module ConnectN
  class GameSetup
    attr_reader :parameters, :game

    def initialize
      @parameters = { human_players: [] }
    end

    def launch
      unless File.exist?('saved_games.yaml')
        if !Game.saved_games('saved_games').empty? && Game.resume?
          game_name = Game.saved_game_name
          @game = Game.load game_name
          return Game.resume game
        end
      end

      setup_parameters
      @game = if parameters[:mode] == 'multiplayer'
                multiplayer_game
              else
                single_player_game
              end
      game.play
    end

    private

    def setup_parameters
      parameters[:human_players].push [human_name, disc]

      parameters[:min_to_win] = min_to_win

      parameters[:mode] = mode

      if parameters[:mode] == 'multiplayer'
        parameters[:human_players].push [human_name => disc]
      else
        parameters[:difficulty] = difficulty
        parameters[:human_starts?] = human_starts?
      end
    end

    def min_to_win
      PROMPT.ask(
        'Minimum number of aligned similar discs necessary to win : ',
        convert: :int,
        default: 4
      )
    end

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
      Game.new(
        Board.new,
        *players,
        min_to_win: parameters[:min_to_win]
      )
    end

    def single_player_game
      board = Board.new
      players = single_player_players(board)
      Game.new(
        board,
        *players,
        min_to_win: parameters[:min_to_win]
      )
    end

    def multiplayer_players
      parameters[:human_players].map do |name, disc|
        next HumanPlayer.new(name: name, disc: disc) if disc

        HumanPlayer.new(name: name)
      end
    end

    def single_player_players(board)
      name, disc = parameters[:human_players].first
      players = [
        if disc
          HumanPlayer.new name: name, disc: disc
        else
          HumanPlayer.new name: name
        end,
        ComputerPlayer.new(
          board: board,
          opponent_disc: disc,
          min_to_win: parameters[:min_to_win],
          difficulty: parameters[:difficulty]
        )
      ]
      parameters[:human_starts?] ? players : players.rotate
    end
  end
end
