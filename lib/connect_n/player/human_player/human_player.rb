# frozen_string_literal: true

require_relative '../player'
require_relative '../../prompt/prompt'

module ConnectN
  class HumanPlayer < Player
    attr_accessor :save_key

    def initialize(name: 'Human', disc: '🔥', save_key: ':w')
      @save_key = save_key
      super name: name, disc: disc
    end

    def pick
      input = Prompt.ask_for_pick
      input == save_key ? input : input.to_i - 1
    end
  end
end
