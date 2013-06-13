require_relative 'grid'

describe Grid do
  context 'Methods' do
    subject { Grid.new(3 ,5) } 
    it { should respond_to :rows }
    it { should respond_to :cols }
    it { should respond_to :[] }
    it { should respond_to :all_items }
    it { should respond_to :each } # Enumerable

    context 'intializes dimensions correctly' do
      its(:cols) { should eq 5 }
      its(:rows) { should eq 3 }
    end
  end

  it 'rejects invalid dimensions' do
    [
      ->{ Grid.new 2,0},
      ->{ Grid.new -1,2},
    ].each do |bad| 
      expect { bad.call }.to raise_error Grid::BadDimensions
    end
  end

  it 'rejects non-sensical dimensions or bad arity' do
    [
      ->{ Grid.new },
      ->{ Grid.new 3 },
      ->{ Grid.new 'foo', :baz }
    ].each do |bad|
      expect { bad.call }.to raise_error Exception
    end
  end

  context 'about intial grid items' do
    it "contains a grid of 0's without a block" do
      Grid.new( 5, 5 ).all_items.each do | x, y, value | 
        value.should be_zero
      end
    end


    it "all objects are unique when a block given" do
      grid_of_strings = Grid.new( 5, 5 ).all_items.each do | x, y, value | 
        value.should be_zero
      end
    end
  end
  
  context 'querying grid' do
    let(:test_grid) { Grid.new(12,10) {false} }

    it 'allows values to be set' do
      expect {
        test_grid[11][9] = true
      }.to change { test_grid[11][9] }.from(false).to(true)
    end
  end

end