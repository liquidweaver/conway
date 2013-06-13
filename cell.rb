class Cell
  class StateInvalid < Exception; end
  VALID_STATES = [ :alive, :dead ]

  attr_accessor :state

  def initialize(initial_state=:alive)
    @state = initial_state
  end

  def state=( new_state )
    raise StateInvalid, "State must be :alive or :dead" unless 
      VALID_STATES.include? new_state

    @state = new_state
  end

  def dead?
    @state == :dead
  end

  def alive?
    @state == :alive
  end

end