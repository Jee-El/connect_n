# frozen_string_literal: true

class Board
  attr_reader :cols

  def initialize
    @cols = Array.new(7) { Array.new(6) }
    @color_to_emoji = { red: '🔴', yellow: '🟡', nil => '⚪' }
  end

  def initialize_copy(original_board)
    super
    @cols = @cols.dup.map &:dup
    @color_to_emoji = @color_to_emoji.dup
  end

  def drop_disc(pick, color)
    row = cols[pick].index(nil)
    return unless row

    @cols[pick][row] = color
    [color, pick, row]
  end

  def valid_pick?(pick)
    !!cols[pick]&.include?(nil)
  end

  def filled?
    !cols.flatten.index(nil)
  end

  def display
    (cols.first.length - 1).downto(0) do |i|
      cols.each { |col| print @color_to_emoji[col[i]] } and puts
    end
  end

  def at(col, row)
    return if [col, row].any?(&:negative?)

    cols.dig(col, row)
  end
end
