# frozen_string_literal: true

class HealingMagicalObject
  attr_reader :health

  def initialize(health: 200)
    @health = health
  end

  def use(user:, **)
    return if destroyed?

    healed_amount = [health, user.healable_amount].min
    user.receive_healing(healed_amount)

    @health -= healed_amount
  end

  def destroyed?
    @health <= 0
  end
end
