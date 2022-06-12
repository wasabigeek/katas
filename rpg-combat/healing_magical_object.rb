# frozen_string_literal: true

class HealingMagicalObject
  def initialize(health: 200)
    @health = health
  end

  def call(user:, **)
    user.receive_healing(@health)
  end
end
