# frozen_string_literal: true

require_relative './faction'

class Character
  STARTING_HEALTH = 1000
  STARTING_LEVEL = 1

  attr_reader :health, :level

  def initialize(health: nil, level: STARTING_LEVEL)
    @level = level
    @health = health || max_health # needs level to be set first :(
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

  def faction
    Faction.for(self)
  end

  def heal
    return unless alive?
    return if health >= max_health

    self.health += 100
  end

  def join(faction)
    faction.handle_join(self)
  end

  def max_health
    return STARTING_HEALTH + 500 if level >= 6

    STARTING_HEALTH
  end

  protected

  attr_writer :health

  private

  def level_difference_damage_modifier(target:)
    level_difference = level - target.level
    if level_difference >= 5
      1.5
    elsif level_difference <= -5
      0.5
    else
      1
    end
  end
end
