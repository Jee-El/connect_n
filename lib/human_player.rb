# frozen_string_literal: true

require_relative 'player'

class HumanPlayer < Player
  def initialize(name: 'Human', color: :red) = super

  def pick = gets.to_i - 1
end
