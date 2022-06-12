# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require './character'

class CharacterDamageAndHealthTest < Minitest::Test
  def test_starting_health
    character = Character.new
    assert_equal 1000, character.health
  end

  def test_starts_alive
    character = Character.new
    assert character.alive?
  end

  def test_attack_to_other_characters
    character1 = Character.new
    character2 = Character.new

    character1.attack(character2)

    assert_equal character2.health, 900
  end

  def test_attack_till_character_dies
    character1 = Character.new
    character2 = Character.new(health: 100)

    character1.attack(character2)

    assert_equal character2.health, 0
    refute character2.alive?
  end

  def test_attack_on_self_does_nothing
    # I think we shouldn't stop the game if a user mistakenly clicks on themself, for example
    character = Character.new
    character.attack(character)
    assert_equal character.health, Character::STARTING_HEALTH
  end

  def test_attack_does_less_damage_if_target_is_5_levels_higher
    character1 = Character.new
    [
      [5, 100],
      [6, 50],
      [7, 50]
    ].each do |level, expected_damage|
      character2 = Character.new(level:)
      character1.attack(character2)
      assert_equal character2.max_health - character2.health, expected_damage
    end
  end

  def test_attack_does_more_damage_if_target_is_5_levels_lower
    character1 = Character.new(level: 6)
    character2 = Character.new

    character1.attack(character2)

    assert_equal character2.health, 850
  end

  def test_heal_when_damaged
    character = Character.new(health: 100)
    character.heal
    assert_equal character.health, 200
  end

  def test_heal_when_damaged_accounts_for_max_health
    character = Character.new(level: 6, health: 1400)
    character.heal
    assert_equal 1500, character.health

    character.heal
    assert_equal 1500, character.health
  end

  def test_heal_does_nothing_when_full_health
    character = Character.new
    initial_health = character.health
    character.heal
    assert_equal initial_health, character.health
  end

  def test_heal_does_nothing_when_dead
    character = Character.new(health: 0)
    character.heal
    assert_equal 0, character.health
  end
end

class CharacterLevelsTest < Minitest::Test
  def test_starting_level
    character = Character.new
    assert_equal 1, character.level
  end

  def test_starting_health_increases_at_level6
    character = Character.new(level: 6)
    assert_equal 1500, character.health
  end
end

class CharacterFactionsTest < Minitest::Test
  def test_starting_faction_is_nil
    character = Character.new
    assert_nil character.faction
  end

  def test_joining_a_faction
    character = Character.new
    faction_mock = Minitest::Mock.new
    faction_mock.expect(:handle_join, true, [character])
    character.join(faction_mock)
    faction_mock.verify
  end
end
