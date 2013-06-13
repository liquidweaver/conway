class Grid
	include Enumerable
	
	class BadDimensions < Exception; end

	def initialize( rows, cols, &block )
		# XXX No testing for Integer type
		raise BadDimensions, "Each dimension must be > 1" if
			[cols, rows].any? { |e| e < 1 }

		block ||= ->{ 0 }
		@grid_data = Array.new( rows ) { Array.new( cols ) { block.call } }

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

	def each
		@grid_data.each { |row| yield row }
	end

	def all_items
		Enumerator.new do |y|
			@grid_data.each_with_index do |row, row_index|
				row.each_with_index do |column, col_index|
					y.yield col_index, row_index, column
				end
			end
		end
	end


end