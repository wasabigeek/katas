# frozen_string_literal: true

require 'minitest/autorun'
require './character'
require './faction'

class IntegrationTest < Minitest::Test
  def test_faction_joining
    character = Character.new
    faction = Faction.new
    character.join(faction)
    assert_equal faction, character.faction
  end
end
