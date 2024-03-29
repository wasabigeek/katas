# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/mock'
require 'character'

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
    assert_equal 1, character.level.to_i
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

class CharacterUseObjectTest < Minitest::Test
  def test_use_on_self
    character = Character.new
    object_mock = Minitest::Mock.new
    object_mock.expect(:use, true, [{ user: character, target: character }])
    character.use(object_mock)
    object_mock.verify
  end

  def test_use_on_target
    character = Character.new
    character2 = Character.new
    object_mock = Minitest::Mock.new
    object_mock.expect(:use, true, [{ user: character, target: character2 }])
    character.use(object_mock, target: character2)
    object_mock.verify
  end
end

class CharacterLevelUpTest < Minitest::Test
  def test_level_1_character_does_not_level_up_if_damage_less_than_1000
    character = Character.new(health: 1100, level: 1)
    character.receive_damage(500)
    assert_equal 1, character.level.to_i
  end

  def test_level_1_character_levels_up_after_receiving_1000_damage
    character = Character.new(health: 1200, level: 1)
    character.receive_damage(600)
    character.receive_damage(500)
    assert_equal 2, character.level.to_i
  end

  def test_level_2_character_levels_up_after_receiving_2000_damage
    character = Character.new(health: 1200, level: 2)
    character.receive_damage(1100)
    assert_equal 2, character.level.to_i
    character.receive_healing(1000)
    character.receive_damage(900)
    # level up should not happen until the next tier of damage is reached
    character.receive_damage(100)
    assert_equal 3, character.level.to_i
  end

  def test_character_does_not_level_up_upon_death
    character = Character.new(health: 1000, level: 1)
    character.receive_damage(1000)
    assert_equal 1, character.level.to_i
  end

  def test_level_1_character_does_not_level_up_if_joined_factions_less_than_3
    faction = Faction.new
    character = Character.new(level: 1)
    character.join(faction)
    assert_equal 1, character.level.to_i
  end

  def test_level_1_character_levels_up_if_joined_factions_is_3
    character = Character.new(level: 1)
    3.times { character.join(Faction.new) }
    assert_equal 2, character.level.to_i
  end

  def test_level_1_character_does_not_level_up_if_joined_factions_are_not_unique
    character = Character.new(level: 1)
    faction = Faction.new
    3.times { character.join(faction) }
    assert_equal 1, character.level.to_i
  end

  def test_character_levels_up_if_joined_factions_is_level_times_3
    character = Character.new(level: 1)
    6.times { character.join(Faction.new) }
    assert_equal 3, character.level.to_i
  end

  def test_character_cannot_go_beyond_level_10
    character = Character.new(level: 1)
    30.times { character.join(Faction.new) }
    assert_equal 10, character.level.to_i
  end

  # TODO: This seems debatable
  # def test_character_levels_up_correctly_with_multiple_objectives
  #   character = Character.new(health: 1100, level: 1)
  #   faction = Faction.new
  #   3.times { character.join(faction) } # wrong in current logic, needs to be 6
  #   character.receive_damage(1000)
  #   assert_equal 3, character.level.to_i
  # end
end
