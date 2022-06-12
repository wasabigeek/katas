# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../character'
require_relative '../faction'
require_relative '../healing_magical_object'

class IntegrationTest < Minitest::Test
  def test_faction_joining_and_leaving
    character = Character.new
    assert character.factions.empty?

    faction = Faction.new
    character.join(faction)
    assert_includes character.factions, faction

    character.leave(faction)
    assert character.factions.empty?
  end

  def test_healing_magical_object_usage
    character = Character.new(health: 800)
    healing_object = HealingMagicalObject.new(health: 150)
    character.use(healing_object)
    assert_equal character.health, 950
  end
end
