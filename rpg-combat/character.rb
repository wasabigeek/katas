# frozen_string_literal: true

class Character
  STARTING_HEALTH = 1000
  STARTING_LEVEL = 1

  attr_reader :health, :level

  def initialize(health: nil, level: STARTING_LEVEL)
    @level = level
    @health = health || max_health(level:)
  end

  def alive?
    health > 0
  end

  def attack(target)
    return if target == self

    target.health -= 100 # waiting for more info before deciding how to encapsulate
  end

  def heal
    return if health >= max_health(level:)

    self.health += 100
  end

  protected

  attr_writer :health

  private

  def max_health(level:)
    return STARTING_HEALTH + 500 if level >= 6

    STARTING_HEALTH
  end
end
