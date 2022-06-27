# frozen_string_literal: true

require_relative './magical_object'

class MagicalWeapon < MagicalObject
  def initialize(health:, damage:)
    @damage = damage
    super(health:)
  end

  def use(user:, target:)
    not_destroyed do
      damage = @damage
      damage *= faction_damage_modifier(user, target)
      damage *= level_difference_damage_modifier(user, target)
      target.receive_damage(damage)

      @health -= 1
    end
  end

  private

  def faction_damage_modifier(user, target)
    if Faction.allies?(user, target)
      0
    else
      1
    end
  end

  def level_difference_damage_modifier(user, target)
    level_difference = user.level - target.level
    if level_difference >= 5
      1.5
    elsif level_difference <= -5
      0.5
    else
      1
    end
  end
end
