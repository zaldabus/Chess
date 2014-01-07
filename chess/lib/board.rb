require_relative 'pieces'

class Board

  def self.generate_board
    Array.new(8) { Array.new(8) }
  end

  def initialize(board = self.class.generate_board)
    @board = board
    populate_board
  end

  def populate_board
    make_complex_row(0, :white)
    make_pawn_row(1, :white)
    make_complex_row(7, :black)
    make_pawn_row(6, :black)
  end

  def make_complex_row(row, color)
    (0..7).each do |i|
      case i
      when 0, 7
        self[[i, row]] = Rook.new(self, [i, row], color)
      when 1, 6
        self[[i, row]] = Knight.new(self, [i, row], color)
      when 2, 5
        self[[i, row]] = Bishop.new(self, [i, row], color)
      when 3
        if color == :white
          self[[i, row]] = Queen.new(self, [i, row], color)
        else
          self[[i, row]] = King.new(self, [i, row], color)
        end
      when 4
        if color == :white
          self[[i, row]] = King.new(self, [i, row], color)
        else
          self[[i, row]] = Queen.new(self, [i, row], color)
        end
      end
    end
  end

  def make_pawn_row(row, color)
     (0..7).each {|i| self[[i, row]] = Pawn.new(self, [i, row], color)}
  end

  def render
    @board.each {|row| p row}
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @board[7 - y][x]
  end

  def []=(pos, value)
    x, y = pos[0], pos[1]
    @board[7 - y][x] = value
  end


end