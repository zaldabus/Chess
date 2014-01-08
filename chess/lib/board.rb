# encoding: UTF-8
require_relative 'pieces'
require 'colorize'

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

  def [](pos)
    x, y = pos[0], pos[1]
    @board[y][x]
  end

  def []=(pos, value)
    x, y = pos[0], pos[1]
    @board[y][x] = value
  end

  def checkmate?(color)
    if in_check?(color)
      @board.flatten.each do |piece|
        next if piece.nil? || piece.color != color
        return false unless piece.all_valid_moves.empty?
      end
      true
    else
      false
    end
  end

  def in_check?(color)
    location = @board
      .flatten
      .select { |piece| piece.class == King && piece.color == color }
      .last
      .location

    @board.flatten.each do |piece|
      next if piece.nil?
      return true if piece.all_moves.include?(location)
    end
    false
  end

  def move(start_position, end_position)
      self[start_position].location = end_position
      self[end_position] = self[start_position]
      self[start_position] = nil
  end

  def render
    black = :on_light_white
    white = :on_light_black

    @board.each_with_index do |row, i|
      color = (i.even? ? white : black)
      row.each_with_index do |space, j|
        space = " " if space.nil?
        print space.to_s.send(color)
        color = (color == white ? black : white)
      end
      puts
    end

  end

  def dup
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

  private
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
        self[[i, row]] = Queen.new(self, [i, row], color)
      when 4
        self[[i, row]] = King.new(self, [i, row], color)
      end
    end
  end

  def make_pawn_row(row, color)
     (0..7).each {|i| self[[i, row]] = Pawn.new(self, [i, row], color)}
  end

end