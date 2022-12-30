# frozen_string_literal: true

require 'tty-prompt'

require_relative '../player'

module ConnectN
  class HumanPlayer < Player
    def initialize(name: 'Human', disc: '🔥') = super

    def pick
      input = PROMPT.ask('Please enter a column number : ')&.downcase
      input == ':w' ? input : input.to_i - 1
    end
  end
end
