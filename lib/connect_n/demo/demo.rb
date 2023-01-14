# frozen_string_literal: true

require_relative '../player/human_player/human_player'
require_relative '../player/computer_player/computer_player'
require_relative '../game/game'
require_relative '../board/board'
require_relative '../prompt/prompt'

module ConnectN
  class Demo
    attr_reader :parameters, :game

    def initialize
      @parameters = { human_players: [] }
    end

    def launch(yaml_fn)
      if !Game.games(yaml_fn).empty? && Game.resume?
        game_name = Game.select_game_name
        @game = Game.load game_name, yaml_fn
        return Game.resume game
      end

      setup_parameters
      @game = if parameters[:mode] == 'multiplayer'
                multiplayer_game
              else
                single_player_game
              end
      game.play(yaml_fn)
    end

    private

    def setup_parameters
      parameters[:human_players].push [Prompt.ask_for_human_name, Prompt.ask_for_disc]

      parameters[:cols_amount] = Prompt.ask_for_cols_amount
      parameters[:rows_amount] = Prompt.ask_for_rows_amount
      parameters[:min_to_win] = Prompt.ask_for_min_to_win

      parameters[:mode] = Prompt.ask_for_mode

      if parameters[:mode] == 'multiplayer'
        parameters[:human_players].push [Prompt.ask_for_human_name, Prompt.ask_for_disc]
      else
        parameters[:difficulty] = Prompt.ask_for_difficulty
        parameters[:human_starts?] = Prompt.human_starts?
      end
    end

    def multiplayer_game
      human_players = multiplayer_players
      board = Board.new(
        cols_amount: parameters[:cols_amount],
        rows_amount: parameters[:rows_amount]
      )
      Game.new(
        board: board,
        first_player: human_players.first,
        second_player: human_players.last,
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
