# frozen_string_literal: true

require 'minitest/autorun'
require './character'
require './faction'

class IntegrationTest < Minitest::Test
  def test_faction_joining_and_leaving
    character = Character.new
    faction = Faction.new
    character.join(faction)
    assert_equal faction, character.faction

    character.leave_faction
    assert_nil character.faction
  end
end
