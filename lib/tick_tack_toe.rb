class TickTackToe
  def initialize
    @board = [[".",".","."],[".",".","."],[".",".","."]]
    @turn = "X"
    @result = ""
  end

  def render_on(html)
    html.heading("Tick Tack Toe")
    html.tag("p"){html.link("start") {initialize}}
      html.tag("table") {
        3.times { |row|
        html.tag("tr") {
          3.times { |col|
          html.tag("td") {
            html.link(@board[row][col]) { do_turn(row, col) }
            }
          }
        }
      }
    }
    html.tag("p"){html.text(@result)}
  end

  def do_turn(row, col)
    @board[row][col] = @turn
    @turn = @turn == "X" ? "O" : "X"

    #check result - not optimized
    @board.each { |row|
    if row[0] != "." && (row[0] == row[1]) && (row[0] == row[2])
      @result = "#{row[1]} won"
    end
    }

    3.times {|col|
      if @board[0][col] != "." && (@board[0][col] == @board[1][col]) && (@board[0][col] == @board[2][col])
        @result = "#{@board[0][col]} won"
      end
    }

    if @board[0][0] != "." && (@board[0][0] == @board[1][1]) && (@board[0][0] == @board[2][2])
      @result = "#{@board[0][0]} won"
    end

    if @board[0][2] != "." && (@board[0][2] == @board[1][1]) && (@board[0][2] == @board[2][0])
      @result = "#{@board[0][2]} won"
    end
  end

end
