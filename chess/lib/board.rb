require 'pieces'

class Board

  # @board is the 2d array
  # attr_reader :board

  def [](pos)
    x, y = pos[0], pos[1]
    @board[x][y]
  end

  def []=(pos, value)
    x, y = pos[0], pos[1]
    @board[x][y] = value
  end

  def out_of_bounds?(pos)
    x, y = pos[0], pos[1]
    x < 0 || y < 0 || x > 8 || y > 8
  end


end