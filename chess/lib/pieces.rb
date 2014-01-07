require 'debugger'

class Piece

  def initialize(loc, color)
    @location, @color = loc, color
  end

  def moves(board)

  end

  def out_of_bounds?(pos)
    x, y = pos[0], pos[1]
    x < 0 || y < 0 || x >= 8 || y >= 8
  end
end


class SlidingPiece < Piece

  MOVES = {
    diagonal_moves: [
      [-1,  1],
      [-1, -1],
      [ 1,  1],
      [ 1, -1]
    ],
    horizontal_moves: [
      [ 0,  1],
      [ 0, -1],
      [ 1,  0],
      [-1,  0]
    ],
    queen_moves: [
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

    debugger
    MOVES[type_of_move].each do |position|
      x_dir, y_dir = position[0], position[1]
      position = [@location[0] + x_dir, @location[1] + y_dir]
      until out_of_bounds?(position)

        unless board[position].nil?
          all_possible_moves << pos if board[position].color != @color
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

end


class Pawn < Piece

end


class Rook < SlidingPiece

  def move_dirs(board)
    all_possible_moves = []

    debugger
    HORIZONTAL_MOVES.each do |position|
      x_dir, y_dir = position[0], position[1]
      position = [@location[0] + x_dir, @location[1] + y_dir]
      until out_of_bounds?(position)

        unless board[position].nil?
          all_possible_moves << pos if board[position].color != @color
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


class Bishop < SlidingPiece

  def move_dirs

  end

end


class Queen < SlidingPiece

  def move_dirs

  end

end


class Knight < SteppingPiece

  MOVES = [
  [-2, -1],
  [-2,  1],
  [-1, -2],
  [-1,  2],
  [ 1, -2],
  [ 1,  2],
  [ 2, -1],
  [ 2,  1]
  ]


end


class King < SteppingPiece

  MOVES = [
  [ 0,  1],
  [ 0, -1],
  [ 1,  1],
  [ 1,  0],
  [ 1, -1],
  [-1,  0],
  [-1, -1],
  [-1,  1]
  ]

  def moves

  end

end