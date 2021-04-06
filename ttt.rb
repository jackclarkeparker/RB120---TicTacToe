=begin

#### DESCRIPTION

Tic Tac Toe is a 2-player board game played on a 3x3 grid. Players take turns
marking a square. The first player to mark 3 squares in a row wins.

|
|
|
#### NOUNS AND VERBS

Nouns: board, player, grid, square
Verbs: mark, play

|
|
|
#### ASSOCIATE NOUNS AND SQUARES

Board
Square
Player
- mark
- play

|
|
|
#### SPIKE

=end

# class Board
#   def initialize
#     # we need some way to model the 3x3 grid. Maybe "squares"?
#     # What data structure should we use?
#     #       - How to determine whether 3 squares have been lined up with the
#     #         same mark? (this goes into the decision)
#     #         - This question doesn't rely on the way that each square is
#     #           represented but is more about the data structure that those
#     #           objects are stored in.
#     # - array/hash of Square objects?
#     # - array/hash of strings or integers?
#   end
# end

# class Square
#   def initialize
#     # Maybe a 'status' to keep track of this square's mark?
#   end

# end

# class Player
#   def initialize
#     # Maybe a 'marker' to keep track of this player's symbol (ie 'X' or 'O')
#   end

#   def mark

#   end
# end

# class TTTGame
#   def play
#     display_welcome_message
#     loop do
#       display_board
#       first_player_moves
#       break if someone_won? || board_full?

#       second_player_moves
#       break if someone_won? || board_full?
#     end
#     display_result
#     display_goodbye_message
#   end
# end

# # we'll kick off the game like this
# game = TTTGame.new
# game.play


class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end

  def get_square_at(key)
    @squares[key]
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    @squares.select { |_, sq| sq.unmarked? }.keys
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      markers = squares.map(&:marker)
      markers.uniq!

      next if markers.include?(' ')
      return markers.first if markers.size == 1
    end
    nil
  end

  def reset
    1.upto(9) { |key| @squares[key] = Square.new }
  end
end

class Square
  INITIAL_MARKER = ' '
  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end

  def to_s
    @marker
  end
end

class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_TO_PLAY = HUMAN_MARKER

  attr_reader :board, :human, :computer
  attr_accessor :current_player

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_PLAY
  end

  def play
    clear
    display_welcome_message

    loop do
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?
        clear_screen_and_display_board if human_turn?
      end
      display_result
      break unless play_again?
      self.reset
      display_play_again_message
    end

    display_goodbye_message
  end

  private

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}."
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def current_player_moves
    case @current_marker
    when HUMAN_MARKER    then human_moves
    when COMPUTER_MARKER then computer_moves
    end
    if @current_marker == HUMAN_MARKER
      @current_marker = COMPUTER_MARKER
    else
      @current_marker = HUMAN_MARKER
    end
  end

  def human_moves
    puts "Choose an empty square (#{board.unmarked_keys.join(", ")})"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if (board.unmarked_keys).include?(square)
      puts "Sorry, incorrect input."
    end

    board[square] = human.marker
  end

  def computer_moves
    square = board.unmarked_keys.sample
    board[square] = computer.marker
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when HUMAN_MARKER    then puts "You won!"
    when COMPUTER_MARKER then puts "Computer won!"
    else                      puts "It's a tie!"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(yes y no n).include?(answer)
      puts "Sorry, must be y or n"
    end

    answer.start_with?('y')
  end

  def reset
    clear
    @current_marker = FIRST_TO_PLAY
    board.reset
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def clear
    system('clear')
  end
end

game = TTTGame.new
game.play