require_relative 'pieces'
require 'debugger'

class Board

  attr_reader :board

  def self.generate_board
    Array.new(8) { Array.new(8) }
  end

  def initialize(board = nil)
    if board.nil?
      @board = self.class.generate_board
      populate_board
    else
      @board = board
    end
  end

  def populate_board
    make_complex_row(7, :white)
    make_pawn_row(6, :white)
    make_complex_row(0, :black)
    make_pawn_row(1, :black)
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

  def in_check?(color)
    location = @board
      .flatten
      .select { |piece| piece.class == King && piece.color == color }
      .last
      .location

      p location
    @board.flatten.each do |piece|
      next if piece.nil?
      if piece.all_moves.include?(location)

        return true
      end
    end
    false
  end

  def move(start_position, end_position)
      self[start_position].location = end_position
      self[end_position] = self[start_position]
      self[start_position] = nil
  end

  def render
    @board.each {|row| p row}
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @board[y][x]
  end

  def []=(pos, value)
    x, y = pos[0], pos[1]
    @board[y][x] = value
  end

  def dup

    # new_board = Board.new(@board.dup.map do |row|
#       row.dup.map do |col|
#         col
#       end
#     end)
#
#     new_board.board.map! do |row|
#       row.map! do |col|
#         next if col.nil?
#         col.dup(new_board)
#       end
#     end
#     new_board

    new_board = Board.new
    self.board.each_with_index do |row, i|
      row.each_with_index do |space, j|
        if space
          new_board[[j, i]] = space.dup(new_board)
        else
          new_board[[j, i]] = space
        end
      end
    end

    new_board
  end

end