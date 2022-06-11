class Character
  STARTING_HEALTH = 1000

  attr_accessor :health

  def initialize(health: STARTING_HEALTH)
    @health = health
  end

  def alive?
    health > 0
  end

  def attack(target)
    target.health -= 100 # waiting for more info before deciding how to encapsulate
  end
end
