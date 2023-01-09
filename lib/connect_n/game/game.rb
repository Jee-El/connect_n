# frozen_string_literal: true

require 'tty-box'
require 'yaml'

require_relative '../player/human_player/human_player'
require_relative '../player/computer_player/computer_player'
require_relative '../board/board'
require_relative '../winnable/winnable'

module ConnectN
  class Game
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

    def play(yaml_fn = nil)
      welcome(board)
      loop do
        current_player = players.first

        pick = current_player.pick

        break self.class.save(self, self.class.name_game, yaml_fn) if self.class.save? pick

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

    def self.load(name, yaml_fn) = games(yaml_fn)[name.to_sym]

    def self.games(yaml_fn)
      YAML.safe_load_file(
        yaml_fn,
        permitted_classes: PERMITTED_CLASSES,
        aliases: true
      ) || {}
    end

    def self.save(game, name, yaml_fn)
      games = games(yaml_fn)
      games[name.to_sym] = game
      dumped_games = YAML.dump(games)
      File.write(yaml_fn, dumped_games)
    end

    def self.name_game = PROMPT.ask 'Name your game : '

    def self.select_game_name(yaml_fn)
      games = games(yaml_fn).keys.map.with_index(1) { "#{_2} -> #{_1}" }
      PROMPT.select 'Choose a saved game : ', games, convert: :sym
    end

    def welcome
      text = <<~TEXT
        Welcome to Connect Four
        #{'    '}
        To play, Enter a number from 1
        to #{board.cols_amount}
        The number corresponds to the
        column order starting from the
        left.
        Enter anything to proceed.
      TEXT
      puts TTY::Box.frame text, padding: 2, align: :center
      board.draw
    end

    def invalid_pick
      PROMPT.error 'Invalid Column Number'
    end

    def over(winner)
      phrase = board.filled? ? 'It is a tie!' : "#{winner.name} has won!"
      puts TTY::Box.sucess(phrase)
    end

    private

    def clear_display
      puts "\e[1;1H\e[2J"
    end
  end
end
