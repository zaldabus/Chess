require_relative 'board'
require_relative 'humanplayer'
require 'debugger'

class Game
  def initialize(player1, player2)
    @game_board = Board.new
    @players = { :white => player1, :black => player2}
    @turn = :white
  end

  def play
    loop do
      @game_board.render

      begin
        start_move, end_move = @players[@turn].play_turn
        unless @game_board[start_move].all_valid_moves.include?(end_move) &&
          @game_board[start_move].color == @turn
          raise StandardError
        end
        @game_board.move(start_move, end_move)
      rescue
        puts "Invalid Move! Try Again."
        retry
      end

      break if over?
      @turn = (@turn == :white ? :black : :white)
    end

    puts "Checkmate! #{@players[@turn].name} won!"
  end

  def over?
    @game_board.checkmate?(:white) || @game_board.checkmate?(:black)
  end
end