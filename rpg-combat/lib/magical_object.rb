# frozen_string_literal: true

class MagicalObject
  attr_reader :health

  def initialize(health:)
    @health = health
  end

  def use(user:, target:)
    raise NotImplementedError
  end

  def destroyed?
    @health <= 0
  end

  private

  def not_destroyed
    yield unless destroyed?
  end
end
