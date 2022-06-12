# frozen_string_literal: true

require_relative './magical_object'

class MagicalWeapon < MagicalObject
  def initialize(health:, damage:)
    @damage = damage
    super(health:)
  end

  def use(target:, **)
    not_destroyed do
      target.receive_damage(@damage)
      @health -= 1
    end
  end
end
