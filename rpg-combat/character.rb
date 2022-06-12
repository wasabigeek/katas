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
    # TODO: account for death?
    return if target == self

    damage = 100
    damage *= faction_damage_modifier(target:)
    damage *= level_difference_damage_modifier(target:)
    target.health -= damage
  end

  def factions
    Faction.for(self)
  end

  def heal(target = self)
    return unless alive? && target.alive?
    return if target.health >= target.max_health
    return if target != self && !Faction.allies?(self, target)

    target.health += 100
  end

  def use(magical_object, target: self)
    magical_object.call(user: self, target:)
  end

  def join(faction)
    faction.handle_join(self)
  end

  def leave(faction)
    faction.handle_leave(self)
  end

  def max_health
    return STARTING_HEALTH + 500 if level >= 6

    STARTING_HEALTH
  end

  def receive_healing(amount)
    self.health += amount
  end

  def healable_amount
    max_health - health
  end

  protected

  attr_writer :health

  private

  def faction_damage_modifier(target:)
    if Faction.allies?(self, target)
      0
    else
      1
    end
  end

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
