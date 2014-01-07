require 'pieces'

class Board

  # @board is the 2d array
  # attr_reader :board

  def [](pos)
    x, y = pos[0], pos[1]
    @board[7 - y][x]
  end

  def []=(pos, value)
    x, y = pos[0], pos[1]
    @board[7 - y][x] = value
  end


end