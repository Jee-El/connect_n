# frozen_string_literal: true

module ConnectFour
  class Player
    attr_reader :name, :color
  
    def initialize(name:, color:)
      @name = name
      @color = color
    end
  end
end

