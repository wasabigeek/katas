# frozen_string_literal: true

require_relative './faction'

class Character
  STARTING_HEALTH = 1000
  STARTING_LEVEL = 1

  attr_reader :health, :level

  def initialize(health: nil, level: STARTING_LEVEL)
    @level = level
    @health = health || max_health # needs level to be set first :(

    @cumulative_damage = 0
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
    target.receive_damage(damage)
  end

  def factions
    Faction.for(self)
  end

  def heal(target = self)
    return unless alive?
    return if target != self && !Faction.allies?(self, target)

    target.receive_healing(100)
  end

  def use(magical_object, target: self)
    magical_object.use(user: self, target:)
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

  def receive_damage(amount)
    damage = [amount, health].min
    @health -= damage
    @cumulative_damage += damage

    @level += 1 if alive? && @cumulative_damage >= @level * 1000
  end

  def receive_healing(amount)
    return unless alive?

    @health += [amount, healable_amount].min
  end

  def healable_amount
    max_health - health
  end

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
