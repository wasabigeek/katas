# frozen_string_literal: true

require_relative './magical_object'

class HealingMagicalObject < MagicalObject
  def initialize(health: 200)
    super(health:)
  end

  def use(user:, **)
    not_destroyed do
      healed_amount = [health, user.healable_amount].min
      user.receive_healing(healed_amount)

      @health -= healed_amount
    end
  end
end
