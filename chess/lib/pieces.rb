require 'debugger'

class Piece
  attr_reader :color, :location

  def initialize(board, location, color)
    @board, @location, @color = board, location, color
  end

  def out_of_bounds?(pos)
    x, y = pos[0], pos[1]
    x < 0 || y < 0 || x >= 8 || y >= 8
  end

  def to_s
    self.class
  end

  def moves(move_deltas)
    @all_possible_moves = []

    move_deltas.each do |position|
      x_dir, y_dir = position[0], position[1]
      position = [@location[0] + x_dir, @location[1] + y_dir]

      sliding_moves(position, x_dir, y_dir) if self.is_a?(SlidingPiece)
      stepping_moves(position) if self.is_a?(SteppingPiece)

    end

    @all_possible_moves
  end

  def sliding_moves(position, x_dir, y_dir)
    until out_of_bounds?(position)

      unless @board[position].nil?
        @all_possible_moves << position.dup if @board[position].color != @color
        break
      else
        @all_possible_moves << position.dup
        position[0] += x_dir
        position[1] += y_dir
      end
    end
  end

  def stepping_moves(position)
    return if out_of_bounds?(position)
    if @board[position].nil?
      @all_possible_moves << position.dup
    else
      @all_possible_moves << position.dup if @board[position].color != @color
    end
  end

end


class SlidingPiece < Piece

  MOVES = {
    diagonal: [
      [-1,  1],
      [-1, -1],
      [ 1,  1],
      [ 1, -1]
    ],
    horizontal: [
      [ 0,  1],
      [ 0, -1],
      [ 1,  0],
      [-1,  0]
    ],
    queen: [
      [-1,  1],
      [-1, -1],
      [ 1,  1],
      [ 1, -1],
      [ 0,  1],
      [ 0, -1],
      [ 1,  0],
      [-1,  0]
    ]
  }

  def moves(type_of_move)
    super(MOVES[type_of_move])
  end

end


class SteppingPiece < Piece

  MOVES = {
    knight: [
      [-2, -1],
      [-2,  1],
      [-1, -2],
      [-1,  2],
      [ 1, -2],
      [ 1,  2],
      [ 2, -1],
      [ 2,  1]
    ],
    king: [
      [-1,  1],
      [-1, -1],
      [ 1,  1],
      [ 1, -1],
      [ 0,  1],
      [ 0, -1],
      [ 1,  0],
      [-1,  0]
    ]
  }

  def moves(type_of_move)
    super(MOVES[type_of_move])
  end

end


class Pawn < Piece

  MOVES = {
    white: [
      [-1, 1],
      [ 1, 1],
      [ 0, 1],
      [ 0, 2]
    ],

    black: [
      [-1, -1],
      [ 1, -1],
      [ 0, -1],
      [ 0, -2]
    ]
   }

  def initialize(board, loc, color)
    super(board, loc, color)
    @moved = false
  end

  def moved
    @moved = true
  end

  def moved?
    @moved
  end

  def moves()
    #skips over piece if still hasn't moved
    #diagonals need work
    all_moves = []
    # debugger
    MOVES[@color].each do |move|
      x_dir, y_dir = move[0], move[1]
      position = [@location[0] + x_dir, @location[1] + y_dir]

      next if y_dir.abs == 2 && moved?
      next if out_of_bounds?(position)
      break if !@board[position].nil? && x_dir == 0

      if x_dir.abs == 1 && !@board[position].nil?
        all_moves << position.dup if @board[position].color != @color
      elsif x_dir.abs == 0 && @board[position].nil?
        all_moves << position.dup
      end


    end

    all_moves
  end

end


class Rook < SlidingPiece

  def moves
    super(:horizontal)
  end

end


class Bishop < SlidingPiece

  def moves
    super(:diagonal)
  end

end


class Queen < SlidingPiece

  def moves
    super(:queen)
  end

end


class Knight < SteppingPiece

  def moves
    super(:knight)
  end

end


class King < SteppingPiece

  def moves
    super(:king)
  end

end