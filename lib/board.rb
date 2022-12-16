class Board
  attr_reader :cols

  def initialize
    @cols = Array.new(7) { Array.new(6) }
    @color_to_emoji = {red: '🔴', yellow: '🟡', nil => '⚪'}
  end

  def drop_disc(pick, color)
    row_index = @cols[pick].index(nil)
    (@cols[pick][row_index] = color) if row_index
  end

  def valid_pick?(pick)
    !!@cols[pick]&.include?(nil)
  end

  def filled?
    !@cols.flatten.index(nil)
  end

  def to_s
    5.downto(0) do |i|
      @cols.each { |col| print @color_to_emoji[col[i]] }
      puts
    end
  end
end