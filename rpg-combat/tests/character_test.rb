require 'minitest/autorun'
require './character'

class CharacterTest < Minitest::Test
  def test_starting_health
    character = Character.new
    assert_equal 1000, character.health
  end
end
