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

    damage = 100
    damage *= level_difference_damage_modifier(target:)
    target.health -= damage
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

  def level_difference_damage_modifier(target:)
    if target.level - level <= -5
      1.5
    elsif target.level - level >= 5
      0.5
    else
      1
    end
  end
end
