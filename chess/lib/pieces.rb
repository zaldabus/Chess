require 'debugger'

class Piece

  def initialize(loc, color)
    @location, @color = loc, color
  end

  def out_of_bounds?(pos)
    x, y = pos[0], pos[1]
    x < 0 || y < 0 || x >= 8 || y >= 8
  end

  def moves(array)
    moves_dirs
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

  def move_dirs(board, type_of_move)
    all_possible_moves = []

    MOVES[type_of_move].each do |position|
      x_dir, y_dir = position[0], position[1]
      position = [@location[0] + x_dir, @location[1] + y_dir]
      until out_of_bounds?(position)

        unless board[position].nil?
          all_possible_moves << position.dup if board[position].color != @color
          next
        else
          all_possible_moves << position.dup
          position[0] += x_dir
          position[1] += y_dir
        end
      end
    end

    all_possible_moves
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

  def move_dirs(board, type_of_move)
    all_moves = []
    MOVES[type_of_move].each do |move|
      x_dir, y_dir = move[0], move[1]
      position = [@location[0] + x_dir, @location[1] + y_dir]

      next if out_of_bounds?(position)

      if board[position].nil?
        all_moves << position.dup
      else
        all_moves << position.dup if board[position].color != @color
      end

    end

    all_moves
  end

end


class Pawn < Piece

  MOVES = {
    white: [
      [ 0, 1],
      [ 0, 2],
      [-1, 1],
      [ 1, 1]
    ],

    black: [
      [ 0, -1],
      [ 0, -2],
      [-1, -1],
      [ 1, -1]
    ]
   }

  def initialize
    super(loc, color)
    @moved = false
  end

  def moved
    self.moved = true
  end

  def moved?
    @moved
  end

  def move_dirs(board, type_of_move)
    all_moves = []

    MOVES[type_of_move].each do |move|
      x_dir, y_dir = move[0], move[1]
      position = [@location[0] + x_dir, @location[1] + y_dir]
      next if y_dir.abs == 2 && moved

      if x_dir.abs == 1 && !board[position].nil?
        all_moves << position.dup if board[position].color != @color
      elsif board[position].nil?
        all_moves << position.dup
      end
    end

    all_moves
  end

end


class Rook < SlidingPiece

  def move_dirs(board)
    super(board, :horizontal)
  end

end


class Bishop < SlidingPiece

  def move_dirs(board)
    super(board, :diagonal)
  end

end


class Queen < SlidingPiece

  def move_dirs(board)
    super(board, :queen)
  end

end


class Knight < SteppingPiece

  def move_dirs(board)
    super(board, :knight)
  end

end


class King < SteppingPiece

  def move_dirs(board)
    super(board, :king)
  end

end