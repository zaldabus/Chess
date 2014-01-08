class HumanPlayer

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def play_turn
    puts "Please enter your move, #{@name}."
    players_input = gets.chomp
    convert_move_for_chess(players_input)
  end

  private
  def convert_move_for_chess(players_input)
    @horizontal_directional = ("a".."h").to_a

    start_move, end_move = players_input.split(", ")

    start_move = [@horizontal_directional.index(start_move[0]), (8 - start_move[1].to_i)]
    end_move = [@horizontal_directional.index(end_move[0]), (8 - end_move[1].to_i)]

    [start_move, end_move]
  end
end