# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require_relative '../healing_magical_object'

class HealingMagicalObjectTest < Minitest::Test
  def test_call_triggers_healing_on_user_up_to_damage
    object = HealingMagicalObject.new
    character_mock = Minitest::Mock.new
    character_mock.expect(:received_damage, 100)
    character_mock.expect(:receive_healing, true, [100])
    object.call(user: character_mock)
    character_mock.verify
  end

  def test_call_triggers_healing_on_user_up_to_object_health
    object = HealingMagicalObject.new(health: 100)
    character_mock = Minitest::Mock.new
    character_mock.expect(:received_damage, 200)
    character_mock.expect(:receive_healing, true, [100])
    object.call(user: character_mock)
    character_mock.verify
  end

  def test_call_reduces_object_health_by_amount_healed
    object = HealingMagicalObject.new(health: 100)
    character_mock = Minitest::Mock.new
    character_mock.expect(:received_damage, 50)
    character_mock.expect(:receive_healing, true, [50])
    object.call(user: character_mock)

    assert_equal 50, object.health
  end
end
