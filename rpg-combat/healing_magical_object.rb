# frozen_string_literal: true

class HealingMagicalObject
  attr_reader :health

  def initialize(health: 200)
    @health = health
  end

  def call(user:, **)
    healed_amount = [health, user.received_damage].min
    user.receive_healing(healed_amount)

    @health -= healed_amount
  end
end
