# frozen_string_literal: true

require_relative './faction'

module Characters
  class Level
    STARTING = 1
    STARTING_HEALTH = 1000
    MAX_LEVEL = 10

    def initialize(current: STARTING)
      @current = current
    end

    def max_health
      return STARTING_HEALTH + 500 if @current >= 6

      STARTING_HEALTH
    end

    def level_up(character)
      return unless character.alive?
      return if @current >= MAX_LEVEL

      # TODO: potentially will not work if character jumps multiple levels
      @current += 1 if character.cumulative_damage >= @current * 1000
      @current += 1 if Faction.historical_joins_count(character) >= @current * 3
    end

    def -(other)
      to_i - other.to_i
    end

    def to_i
      @current
    end
  end
end

class Character
  STARTING_HEALTH = 1000
  STARTING_LEVEL = 1
  STARTING_WEAPON = MagicalWeapon.new(health: Float::Infinity, damage: 100)

  attr_reader :health, :cumulative_damage, :level

  def initialize(health: nil, level: STARTING_LEVEL)
    @level = Characters::Level.new(current: level)
    @health = health || max_health # needs level to be set first :(

    @cumulative_damage = 0
  end

  def alive?
    health > 0
  end

  # Requirements are unclear on how attacking / using weapons should interplay
  # e.g. should a weapon be equipped, then used?
  # Chose to sidestep that a little for now, assume that attack / use are two different commands.
  # I did however use MagicalWeapon under the hood, which might not be the right coupling.
  def attack(target, weapon: STARTING_WEAPON)
    # TODO: account for death?
    return if target == self

    use(weapon, target:)
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
    @level.level_up(self)
  end

  def leave(faction)
    faction.handle_leave(self)
  end

  def max_health
    @level.max_health
  end

  def receive_damage(amount)
    damage = [amount, health].min
    @health -= damage
    @cumulative_damage += damage

    @level.level_up(self)
  end

  def receive_healing(amount)
    return unless alive?

    @health += [amount, healable_amount].min
  end

  def healable_amount
    max_health - health
  end
end
