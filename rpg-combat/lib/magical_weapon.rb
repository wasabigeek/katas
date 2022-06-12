# frozen_string_literal: true

class MagicalWeapon
  def initialize(damage:)
    @damage = damage
  end

  def call(target:, **)
    target.receive_damage(@damage)
  end
end
