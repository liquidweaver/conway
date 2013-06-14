require_relative '../cell'

describe Cell do
  it { should respond_to :state }

  it "allows :alive and :dead for states" do
    expect { subject.state = :alive }.to_not raise_error
    expect { subject.state = :dead }.to_not raise_error
  end

  it "raises an exception for invalid state values" do 
    expect { subject.state = :happy }.to raise_error Cell::StateInvalid
    expect { subject.state = 34 }.to raise_error Cell::StateInvalid
  end

  context "when alive" do
    subject { Cell.new :alive }

    its(:state) { should eq :alive }
    it { should be_alive }
  end

  context "when dead" do
    subject { Cell.new :dead }

    its(:state) { should eq :dead }
    it { should be_dead }
  end

end