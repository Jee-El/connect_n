# frozen_string_literal: true

require 'tty-prompt'

require_relative '../player'

module ConnectFour
  class HumanPlayer < Player
    def initialize(name: 'Human', disc: '🔥') = super

    def pick
      PROMPT.ask('Please enter a column number : ', convert: :int) - 1
    end
  end
end
