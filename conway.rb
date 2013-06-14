# Conway's Game of Life, Joshua Weaver, 06/13/2013

# This class models the rules of CGL on generic Grid data layer.
# USAGE
#   Instantiate an instance of the class supplying dimensions for the simulation
#   area. Optionally, you can pass a block to new, which should return an array
#   where the length can be evenly divided into rows for purposes of easily 
#   setting the initial state of the game.
#   To run the game, simply call the 'tick' method. The object knows how to 
#   generate a nice string representation - if passes to puts, for example.
#   
# I used the rules provided here: http://en.wikipedia.org/wiki/Conway's_Game_of_Life#Rules
# Any live cell with fewer than two live neighbours dies, as if caused by under-population.
# Any live cell with two or three live neighbours lives on to the next generation.
# Any live cell with more than three live neighbours dies, as if by overcrowding.
# Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

# XXX require_relative considered unsafe
require_relative 'grid'
require_relative 'cell'

class Conway
  def initialize( rows, cols )
    if block_given?
      @game_grid = Grid.new( rows, cols ) { Cell.new }

      # Essentially, the mapping here is just to go from [1,0] to Cells of
      #   [:alive, :dead]
      cell_array = yield.map do |e|
        state = e == 0 ? :dead : :alive
        Cell.new( state )
      end

      @game_grid.unflatten cell_array
    else
      @game_grid = Grid.new( rows, cols ) { Cell.new }
    end
  end

  def tick
    new_game_grid = Grid.new( @game_grid.rows, @game_grid.cols ) { Cell.new }
    ( 0 .. @game_grid.rows - 1).each do |row|
      ( 0 .. @game_grid.cols - 1).each do |col|

        living_neighbors = neighbor_count row, col
        current_state = @game_grid[row][col].state
        new_game_grid[row][col].state = cell_destiny current_state, living_neighbors

      end
    end

    @game_grid = new_game_grid
  end

  def grid
    @game_grid
  end

  def to_s
    @game_grid.to_s do |cell|
      cell.alive? ? '#' : '.'
    end
  end

  private

  def living_rules( neighbors )
    if neighbors < 2
      :dead
    elsif neighbors == 2 or neighbors == 3
      :alive
    else
      :dead
    end
  end

  def dead_rules( neighbors )
    if neighbors == 3
      :alive
    else
      :dead
    end
  end

  # Give the current state of a cell and the amount of neighbors, this method
  # will calculate what the next state should be.
  def cell_destiny( current_state, neighbors )
    case current_state
    when :alive
      living_rules neighbors
    when :dead
      dead_rules neighbors
    end
  end

  def neighbor_count( row, col )
    # This array - product - array will generate deltas to iterate over a 3x3
    #   area centered about the row and column given
    [-1, 0, 1].product([-1, 0, 1]).reduce(0) do | count, deltas |
      cell_row = row + deltas[0]
      cell_col = col + deltas[1]

      if not deltas.all? { |n| n == 0 } and # Don't count self, i.e. center
         @game_grid.valid_position? cell_row, cell_col and
         @game_grid[cell_row][cell_col].alive?
        count + 1
      else
        count
      end

    end
  end

end