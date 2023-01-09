# frozen_string_literal: true

require_relative '../player/human_player/human_player'
require_relative '../player/computer_player/computer_player'
require_relative '../game/game'
require_relative '../board/board'

module ConnectN
  class Demo
    attr_reader :parameters, :game

    def initialize
      @parameters = { human_players: [] }
    end

    def launch
      if !Game.games('connect_n_saved_games.yaml').empty? && Game.resume?
        game_name = Game.pick_game_name
        @game = Game.load game_name, 'connect_n_saved_games.yaml'
        return Game.resume game
      end

      setup_parameters
      @game = if parameters[:mode] == 'multiplayer'
                multiplayer_game
              else
                single_player_game
              end
      game.play('connect_n_saved_games.yaml')
    end

    private

    def setup_parameters
      parameters[:human_players].push [human_name, disc]

      parameters[:cols_amount] = cols_amount
      parameters[:rows_amount] = rows_amount
      parameters[:min_to_win] = min_to_win

      parameters[:mode] = mode

      if parameters[:mode] == 'multiplayer'
        parameters[:human_players].push [human_name => disc]
      else
        parameters[:difficulty] = difficulty
        parameters[:human_starts?] = human_starts?
      end
    end

    def cols_amount
      PROMPT.ask 'How many columns do you want in the board?', convert: :int, default: 7
    end

    def rows_amount
      PROMPT.ask 'How many rows do you want in the board?', convert: :int, default: 6
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
      PROMPT.ask 'Enter a character that will represent your disc : ', default: '🔥' do |q|
        q.validate(/^.?$/)
        q.messages[:valid?] = 'Please enter a single character.'
      end
    end

    def human_name
      PROMPT.ask 'Enter your name : ', default: ENV['USER']
    end

    def multiplayer_game
      human_players = multiplayer_players
      board = Board.new(
        cols_amount: parameters[:cols_amount],
        rows_amount: parameters[:rows_amount]
      )
      Game.new(
        board: board,
        first_player: players.first,
        second_player: players.last,
        min_to_win: parameters[:min_to_win]
      )
    end

    def single_player_game
      board = Board.new(
        cols_amount: parameters[:cols_amount],
        rows_amount: parameters[:rows_amount]
      )
      players = single_player_players(board)
      Game.new(
        board: board,
        first_player: players.first,
        second_player: players.last,
        min_to_win: parameters[:min_to_win]
      )
    end

    def multiplayer_players
      parameters[:human_players].map do |name, disc|
        HumanPlayer.new(name: name, disc: disc)
      end
    end

    def single_player_players(board)
      name, disc = parameters[:human_players].first
      players = [
        HumanPlayer.new(name: name, disc: disc),
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
