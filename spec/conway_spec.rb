require_relative '../conway'

describe Conway do
  subject { Conway.new 10, 10 }
  it { should respond_to :tick }
  it { should respond_to :grid }
  it { should respond_to :to_s }

  context 'respects the rules' do

    it 'and kills any cell with fewer than two live neighbours' do
      subject.send( :cell_destiny, :alive, 0).should eq :dead
      subject.send( :cell_destiny, :alive, 1).should eq :dead
    end

    it 'does not change a live cell with two or three live neighbours' do
      subject.send( :cell_destiny, :alive, 2).should eq :alive
      subject.send( :cell_destiny, :alive, 3).should eq :alive
    end

    it 'and kills any live cell with more than three live neighbours' do
      (4..8).each do |count|
        subject.send( :cell_destiny, :alive, count).should eq :dead
      end
    end

    it 'and creates a live cell from any dead cell with exactly three live neighbours' do
      subject.send( :cell_destiny, :dead, 3).should eq :alive
    end

  end
  
  context "whole field behavior" do
    context "doesn't change" do
      {
        'block' =>
        [
          0,0,0,0,0,0,
          0,1,1,0,0,0,
          0,1,1,0,0,0,
          0,0,0,0,0,0,
          0,0,0,0,0,0,
          0,0,0,0,0,0,
        ],

        'beehive' =>
        [
         0,0,0,0,0,0,
         0,0,1,1,0,0,
         0,1,0,0,1,0,
         0,0,1,1,0,0,
         0,0,0,0,0,0,
         0,0,0,0,0,0,
        ],

        'loaf' =>
        [
         0,0,0,0,0,0,
         0,0,1,1,0,0,
         0,1,0,0,1,0,
         0,0,1,0,1,0,
         0,0,0,1,0,0,
         0,0,0,0,0,0,
        ],

        'boat' =>
        [
          0,0,0,0,0,0,
          0,1,1,0,0,0,
          0,1,0,1,0,0,
          0,0,1,0,0,0,
          0,0,0,0,0,0,
          0,0,0,0,0,0,
        ],

      }.each_pair do |name, pattern|
        it "when given the '#{name}' pattern" do
          test_game = Conway.new( 6, 6 ) { pattern }

          expect {
            test_game.tick
          }.to_not change( test_game, :to_s )
        end

      end

    end # "doesn't change"

    context "simple oscillators" do
      {
        'blinker' =>
        [
          0,0,0,0,0,0,
          0,0,1,0,0,0,
          0,0,1,0,0,0,
          0,0,1,0,0,0,
          0,0,0,0,0,0,
          0,0,0,0,0,0,
        ],

        'toad' =>
        [
         0,0,0,0,0,0,
         0,0,0,0,0,0,
         0,0,1,1,1,0,
         0,1,1,1,0,0,
         0,0,0,0,0,0,
         0,0,0,0,0,0,
        ],

        'beacon' =>
        [
         0,0,0,0,0,0,
         0,1,1,0,0,0,
         0,1,1,0,0,0,
         0,0,0,1,1,0,
         0,0,0,1,1,0,
         0,0,0,0,0,0,
        ],

      }.each_pair do |name, pattern|
        it "when given the '#{name}' pattern" do
          test_game = Conway.new( 6, 6 ) { pattern }

          original = test_game.to_s
          expect {
            test_game.tick
            test_game.to_s.should_not eq original
            test_game.tick
          }.to_not change( test_game, :to_s )
        end

      end

    end # "doesn't change"
  end # "whole field behavior"

end