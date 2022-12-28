# frozen_string_literal: true

require 'yaml'

require_relative '../player/human_player/human_player'
require_relative '../player/computer_player/computer_player'
require_relative '../board/board'
require_relative '../winnable/winnable'
require_relative '../displayable/displayable'

module ConnectFour
  class Game
    include Displayable
    include Winnable

    attr_reader :board, :players

    FILE_NAME = 'saved_games.yaml'

    PERMITTED_CLASSES = [Symbol, Game, Board, HumanPlayer, ComputerPlayer]

    @saved_games = YAML.safe_load_file(FILE_NAME, permitted_classes: PERMITTED_CLASSES)

    def initialize(board, current_player, other_player)
      @board = board
      @players = [current_player, other_player]
    end

    def play
      welcome(board)
      loop do
        current_player = players.first

        pick = current_player.pick

        break self.class.save(self) if save? pick

        next invalid_pick unless board.valid_pick? pick

        row, col, disc = board.drop_disc(current_player.disc, at_col: pick)

        clear_display
        board.display

        break over(current_player) if over?(board, row, col, disc)

        players.rotate!
      end
    end

    def over?(board, row, col, disc)
      win?(board, row, col, disc) || board.filled?
    end

    def play_again?
      PROMPT.yes? 'Would you like to play again?'
    end

    def save?(input) = input == ':w'

    def self.resume?
      PROMPT.yes? 'Do you want to resume a game?'
    end

    def self.resume
      load(saved_game).play
    end

    def self.saved_games(should_update: false)
      return @saved_games unless should_update

      @saved_games = YAML.safe_load_file(File.read(FILE_NAME), permitted_classes: PERMITTED_CLASSES)
    end

    def self.save(game, name = gets.chomp)
      new_game = { name.to_sym => game }
      saved_games.push new_game
      dumped = YAML.dump(saved_games)
      File.write(FILE_NAME, dumped)
    end

    def self.load(name)
      saved_games.find { |k, v| k == name }
    end

    def self.saved_game
      saved_games = saved_games.lazy.map(&:keys).with_index { "#{_2} -> #{_1}" }
      PROMPT.select 'Choose a saved game : ', saved_games
    end
  end
end
