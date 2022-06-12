# frozen_string_literal: true

class MagicalWeapon
  attr_reader :health

  def initialize(health:, damage:)
    @health = health
    @damage = damage
  end

  def call(target:, **)
    return if destroyed?

    target.receive_damage(@damage)
    @health -= 1
  end

  def destroyed?
    @health <= 0
  end
end
