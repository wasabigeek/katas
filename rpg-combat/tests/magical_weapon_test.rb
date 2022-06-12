# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require 'magical_weapon'

class MagicalWeaponTest < Minitest::Test
  def test_call_triggers_damage_on_target
    object = MagicalWeapon.new(health: 10, damage: 200)
    character_mock = Minitest::Mock.new
    character_mock.expect(:receive_damage, true, [200])
    object.call(user: nil, target: character_mock)
    character_mock.verify
  end

  def test_call_causes_health_loss
    object = MagicalWeapon.new(health: 10, damage: 200)
    character_mock = Minitest::Mock.new
    character_mock.expect(:receive_damage, true, [200])
    object.call(user: nil, target: character_mock)

    assert_equal 9, object.health
  end

  def test_destroyed_at_zero_health
    object = MagicalWeapon.new(health: 1, damage: 1)
    refute object.destroyed?

    object2 = MagicalWeapon.new(health: 0, damage: 1)
    assert object2.destroyed?
  end

  def test_call_does_nothing_when_object_is_destroyed
    object = MagicalWeapon.new(health: 0, damage: 1)
    character_mock = Minitest::Mock.new
    object.call(user: nil, target: character_mock)
    character_mock.verify
  end
end
