# frozen_string_literal: true

require_relative './faction'

module Characters
  class Level
    STARTING = 1
    STARTING_HEALTH = 1000

    def initialize(current: STARTING)
      @current = current
    end

    def max_health
      return STARTING_HEALTH + 500 if @current >= 6

      STARTING_HEALTH
    end

    def level_up(character)
      return unless character.alive?

      # TODO: potentially will not work if character jumps multiple levels
      @current += 1 if character.cumulative_damage >= @current * 1000
      @current += 1 if character.cumulative_factions.size >= @current * 3
    end

    def to_i
      @current
    end
  end
end

class Character
  STARTING_HEALTH = 1000
  STARTING_LEVEL = 1

  attr_reader :health, :cumulative_damage, :cumulative_factions

  def initialize(health: nil, level: STARTING_LEVEL)
    @_level = Characters::Level.new(current: level)
    @health = health || max_health # needs level to be set first :(

    @cumulative_damage = 0
    @cumulative_factions = Set.new
  end

  def alive?
    health > 0
  end

  def level
    @_level.to_i
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
    @cumulative_factions << faction
    @_level.level_up(self)
  end

  def leave(faction)
    faction.handle_leave(self)
  end

  def max_health
    @_level.max_health
  end

  def receive_damage(amount)
    damage = [amount, health].min
    @health -= damage
    @cumulative_damage += damage

    @_level.level_up(self)
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
