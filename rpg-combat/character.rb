class Character
  STARTING_HEALTH = 1000

  attr_reader :health

  def initialize
    @health = STARTING_HEALTH
    @alive = true
  end

  def alive?
    @alive
  end
end
