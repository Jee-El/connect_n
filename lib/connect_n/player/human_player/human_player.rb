# frozen_string_literal: true

require 'tty-prompt'

require_relative '../player'

module ConnectN
  class HumanPlayer < Player
    attr_accessor :save_key

    def initialize(name: 'Human', disc: '🔥', save_key: ':w')
      @save_key = save_key
      super name: name, disc: disc
    end

    def pick
      input = PROMPT.ask('Please enter a column number : ')
      input == save_key ? input : input.to_i - 1
    end
  end
end
