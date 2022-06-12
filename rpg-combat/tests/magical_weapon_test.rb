# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require 'magical_weapon'

class MagicalWeaponTest < Minitest::Test
  def test_call_triggers_damage_on_target
    object = MagicalWeapon.new(damage: 200)
    character_mock = Minitest::Mock.new
    character2_mock = Minitest::Mock.new
    character2_mock.expect(:receive_damage, true, [200])
    object.call(user: character_mock, target: character2_mock)
    character2_mock.verify
  end
end
