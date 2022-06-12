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

  def test_attack_on_ally_does_nothing
    _faction, character1, character2 = create_allies
    character1.attack(character2)

    damage = character2.max_health - character2.health
    assert_equal 0, damage
  end

  def test_heal_self_when_damaged
    character = Character.new(health: 100)
    character.heal
    assert_equal character.health, 200
  end

  def test_heal_self_when_damaged_accounts_for_max_health
    character = Character.new(level: 6, health: 1400)
    character.heal
    assert_equal 1500, character.health

    character.heal
    assert_equal 1500, character.health
  end

  def test_heal_self_does_nothing_when_full_health
    character = Character.new
    initial_health = character.health
    character.heal
    assert_equal initial_health, character.health
  end

  def test_heal_self_does_nothing_when_dead
    character = Character.new(health: 0)
    character.heal
    assert_equal 0, character.health
  end

  def test_heal_ally
    _faction, character1, character2 = create_allies(character2_options: { health: 100 })
    character1.heal(character2)

    assert_equal 200, character2.health
  end

  def test_heal_ally_does_nothing_when_self_is_dead
    _faction, character1, character2 = create_allies(
      character1_options: { health: 100 },
      character2_options: { health: 0 }
    )
    character2.heal(character1)
    assert_equal 100, character1.health
  end

  def test_heal_ally_does_nothing_when_ally_is_dead
    _faction, character1, character2 = create_allies(
      character2_options: { health: 0 }
    )
    character1.heal(character2)
    assert_equal 0, character2.health
  end

  def test_heal_non_ally
    character1 = Character.new
    character2 = Character.new(health: 100)
    character1.heal(character2)

    assert_equal 100, character2.health
  end

  private

  def create_allies(character1_options: {}, character2_options: {})
    faction = Faction.new
    character1 = Character.new(**character1_options)
    character2 = Character.new(**character2_options)
    character1.join(faction)
    character2.join(faction)

    [faction, character1, character2]
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
  def test_starting_factions_is_empty
    character = Character.new
    assert character.factions.empty?
  end
end
