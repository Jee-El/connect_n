class Board
  attr_reader :cols

  def initialize
    @cols = Array.new(7) { Array.new(6) }
  end

  def drop_disc(pick, color)
    pick -= 1
    row_index = @cols[pick].index(nil)
    @cols[pick][row_index] = color if row_index
  end
end