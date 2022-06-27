# frozen_string_literal: true

require 'minitest/autorun'
require 'character'
require 'faction'
require 'healing_magical_object'
require 'magical_weapon'

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

    assert healing_object.destroyed?
  end

  def test_magical_weapon_usage
    character = Character.new
    character2 = Character.new(health: 1000)
    weapon = MagicalWeapon.new(health: 1, damage: 100)
    character.use(weapon, target: character2)
    assert_equal character2.health, 900

    assert weapon.destroyed?
  end
end
