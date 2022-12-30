# frozen_string_literal: true

require 'tty-prompt'
require 'tty-box'

module ConnectFour
  module Displayable
    def welcome(board)
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
      puts TTY::Box.success  "#{winner.name} has won!"
    end

    def clear_display
      puts "\e[1;1H\e[2J"
    end
  end
end
