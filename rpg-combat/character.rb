class Character
  STARTING_HEALTH = 1000
  STARTING_LEVEL = 1

  attr_reader :health, :level

  def initialize(health: STARTING_HEALTH, level: STARTING_LEVEL)
    @health = health
    @level = level
  end

  def alive?
    health > 0
  end

  def attack(target)
    return if target == self

    target.health -= 100 # waiting for more info before deciding how to encapsulate
  end

  def heal
    return if health >= STARTING_HEALTH

    self.health += 100
  end

  protected

  attr_writer :health
end
