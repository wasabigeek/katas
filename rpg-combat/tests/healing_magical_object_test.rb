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

  # def test_object_loses_health_after_healing
  #   object = HealingMagicalObject.new(health: 500)
  #   character_mock = Minitest::Mock.new
  #   character_mock.expect(:receive_healing, true, [100])
  #   object.call(user: character_mock)
  #   character_mock.verify
  # end
end
