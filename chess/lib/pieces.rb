require 'debugger'

class Piece
  attr_reader :color, :all_possible_moves, :board
  attr_accessor :location

  def initialize(board, location, color)
    @board, @location, @color = board, location, color
  end

  def out_of_bounds?(pos)
    x, y = pos[0], pos[1]
    x < 0 || y < 0 || x >= 8 || y >= 8
  end

  def to_s
    "#{self.color[0]} #{self.class.to_s[0]}"
  end

  def all_valid_moves(move_deltas)
    @all_possible_moves = []

    move_deltas.each do |position|
      x_dir, y_dir = position[0], position[1]
      position = [@location[0] + x_dir, @location[1] + y_dir]

      sliding_moves(position, x_dir, y_dir) if self.is_a?(SlidingPiece)
      stepping_moves(position) if self.is_a?(SteppingPiece)

    end
    @all_possible_moves.reject {|move| move_into_check?(move)}
  end

  def all_moves(move_deltas)
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

  def move_into_check?(pos)
    copy_board = @board.dup
    copy_board.move(@location, pos)

    bool = copy_board.in_check?(@color) ? true : false

    bool
  end

  def dup(new_board)
    self.class.new(new_board, @location.dup, @color)
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

  def all_valid_moves(type_of_move)
    super(MOVES[type_of_move])
  end

  def all_moves(type_of_move)
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

  def all_valid_moves(type_of_move)
    super(MOVES[type_of_move])
  end

  def all_moves(type_of_move)
    super(MOVES[type_of_move])
  end

end


class Pawn < Piece

  MOVES = {
    white: [
      [-1, -1],
      [ 1, -1],
      [ 0, -1],
      [ 0, -2]
    ],

    black: [
      [-1, 1],
      [ 1, 1],
      [ 0, 1],
      [ 0, 2]
    ]
   }

  def initialize(board, location, color)
    super(board, location, color)
    @moved = false
  end

  def moved
    @moved = true
  end

  def moved?
    @moved
  end

  def all_valid_moves
    all_moves.reject {|move| move_into_check?(move)}
  end

  def all_moves
    @all_possible_moves = []
    MOVES[@color].each do |move|
      x_dir, y_dir = move[0], move[1]
      position = [@location[0] + x_dir, @location[1] + y_dir]

      next if y_dir.abs == 2 && moved?
      next if out_of_bounds?(position)
      break if !@board[position].nil? && x_dir == 0

      if x_dir.abs == 1 && !@board[position].nil?
        @all_possible_moves << position.dup if @board[position].color != @color
      elsif x_dir.abs == 0 && @board[position].nil?
        @all_possible_moves << position.dup
      end
    end

    @all_possible_moves
  end

end


class Rook < SlidingPiece

  def all_valid_moves
    super(:horizontal)
  end

  def all_moves
    super(:horizontal)
  end

end


class Bishop < SlidingPiece

  def all_valid_moves
    super(:diagonal)
  end

  def all_moves
    super(:diagonal)
  end

end


class Queen < SlidingPiece

  def all_valid_moves
    super(:queen)
  end

  def all_moves
    super(:queen)
  end

end


class Knight < SteppingPiece

  def all_valid_moves
    super(:knight)
  end

  def all_moves
    super(:knight)
  end

end


class King < SteppingPiece

  def all_valid_moves
    super(:king)
  end

  def all_moves
    super(:king)
  end

end