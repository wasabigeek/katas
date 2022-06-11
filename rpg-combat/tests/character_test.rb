require 'minitest/autorun'
require './character'

class CharacterTest < Minitest::Test
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

  def test_heal_when_damaged
    character = Character.new(health: 100)
    character.heal
    assert_equal character.health, 200
  end
end
