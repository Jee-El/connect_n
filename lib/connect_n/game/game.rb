# frozen_string_literal: true

require 'yaml'

require_relative '../player/human_player/human_player'
require_relative '../player/computer_player/computer_player'
require_relative '../board/board'
require_relative '../winnable/winnable'
require_relative '../displayable/displayable'

module ConnectN
  class Game
    include Displayable
    include Winnable

    attr_reader :board, :players, :min_to_win

    PERMITTED_CLASSES = [Symbol, Game, Board, HumanPlayer, ComputerPlayer]

    def initialize(
      board:,
      first_player:,
      second_player:,
      min_to_win: 4
    )
      @board = board
      @players = [first_player, second_player]
      @min_to_win = min_to_win
    end

    def play
      welcome(board)
      loop do
        current_player = players.first

        pick = current_player.pick

        break self.class.save(self) if self.class.save? pick

        next invalid_pick unless board.valid_pick? pick

        row_num, col_num, disc = board.drop_disc(current_player.disc, at_col: pick)

        clear_display
        board.draw

        break over(current_player) if over?(board, row_num, col_num, disc)

        players.rotate!
      end
    end

    def over?(board, row, col, disc) = win?(board, row, col, disc) || board.filled?

    def play_again? = PROMPT.yes? 'Would you like to play again?'

    def self.save?(input) = input == ':w'

    def self.resume? = PROMPT.yes? 'Do you want to resume a game?'

    def self.resume(game) = game.play

    def self.load(name, file_name) = games(file_name)[name.to_sym]

    def self.games(file_name)
      YAML.safe_load_file(
        file_name,
        permitted_classes: PERMITTED_CLASSES,
        aliases: true
      ) || {}
    end

    def self.save(game, name, file_name)
      games = games(file_name)
      games[name.to_sym] = game
      dumped_games = YAML.dump(games)
      File.write(file_name, dumped_games)
    end

    def self.game_name = PROMPT.ask('Name your saved game : ')

    def self.list_games(file_name)
      games = games(file_name).keys.each.with_index(1) { "#{_2} -> #{_1}" }
      PROMPT.select 'Choose a saved game : ', games, convert: :sym
    end
  end
end
