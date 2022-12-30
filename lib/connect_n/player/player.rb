# frozen_string_literal: true

module ConnectN
  class Player
    attr_accessor :name, :disc

    def initialize(name:, disc:)
      @name = name
      @disc = disc
    end
  end
end
