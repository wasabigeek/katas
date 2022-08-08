# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require 'healing_magical_object'

class HealingMagicalObjectTest < Minitest::Test
  def test_call_triggers_healing_on_user_up_to_damage
    object = HealingMagicalObject.new
    character_mock = Minitest::Mock.new
    character_mock.expect(:healable_amount, 100)
    character_mock.expect(:receive_healing, true, [100])
    object.use(user: character_mock)
    character_mock.verify
  end

  def test_call_triggers_healing_on_user_up_to_object_health
    object = HealingMagicalObject.new(health: 100)
    character_mock = Minitest::Mock.new
    character_mock.expect(:healable_amount, 200)
    character_mock.expect(:receive_healing, true, [100])
    object.use(user: character_mock)
    character_mock.verify
  end

  def test_call_reduces_object_health_by_amount_healed
    object = HealingMagicalObject.new(health: 100)
    character_mock = Minitest::Mock.new
    character_mock.expect(:healable_amount, 50)
    character_mock.expect(:receive_healing, true, [50])
    object.use(user: character_mock)

    assert_equal 50, object.health
  end

  def test_destroyed_at_zero_health
    object = HealingMagicalObject.new
    refute object.destroyed?

    object2 = HealingMagicalObject.new(health: 0)
    assert object2.destroyed?
  end

  def test_call_does_nothing_when_object_is_destroyed
    object = HealingMagicalObject.new(health: 0)
    character_mock = Minitest::Mock.new
    object.use(user: character_mock)
    character_mock.verify
  end
end
