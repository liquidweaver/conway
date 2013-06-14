# Grid, Joshua Weaver, 06/13/2013

# This class provides a generic container for a 2 dimensional array in Ruby.
# 
# USAGE
#   This implementation is optimized for dense 2d data. If you require
#   a large 2d set of sparse data, this will be inefficient.
#   Convenience methods are provided to convert to and from linear 
#   representations of the data (flatten and unflatten)
class Grid
  include Enumerable
  
  class BadDimensions < Exception; end

  def initialize( rows, cols, &initializer_block )
    raise BadDimensions, "Each dimension must be > 1" if
      [cols, rows].any? { |e| e < 1 }

    initializer_block ||= ->{ 0 }
    @grid_data = Array.new( rows ) do
      Array.new( cols ) { initializer_block.call }
    end

  end

  def unflatten( array )
    raise ArgumentError, "Array length != columns * rows of Grid" if
      array.count != cols * rows

    idx = 0
    array.each_slice(cols) do |new_row|
      @grid_data[idx] = new_row
      idx += 1
    end

  end

  def flatten
    @grid_data.reduce([]) do |acc, row|
      acc += row
    end
  end

  def [](row)
    @grid_data[row]
  end

  def rows
    @grid_data.count
  end

  def cols
    @grid_data.first.count
  end

  def valid_position? row, col 
    row >= 0 and row < rows and col >= 0 and col < cols
  end

  # Allows usage of the Enumerable mixin
  def each
    @grid_data.each { |row| yield row }
  end

  # Convenience method which provides an iterator for all elements
  def all_items
    Enumerator.new do |y|
      @grid_data.each_with_index do |row, row_index|
        row.each_with_index do |column, col_index|
          y.yield col_index, row_index, column
        end
      end
    end
  end


  # A block can be passed to provide the correct string representation
  # for individual items of the Grid
  def to_s
    output = ''
    @grid_data.each do |row|
      output += "| "
      row.each_with_index do |item, idx|
        output += ", " unless idx == 0
        output += if block_given?
          yield item
        else
          item.to_s
        end
      end
      output += " |\n"
    end

    output
  end


end
