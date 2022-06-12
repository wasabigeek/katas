# frozen_string_literal: true

require 'minitest/autorun'
require './character'
require './faction'

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
end
