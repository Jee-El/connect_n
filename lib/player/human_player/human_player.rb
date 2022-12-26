# frozen_string_literal: true

require_relative '../player'

module ConnectFour
  class HumanPlayer < Player
    def initialize(name: 'Human', disc: '🔥') = super
  
    def pick = gets.to_i - 1
  end
end
