# frozen_string_literal: true

class Faction
  @@character_map = Hash.new

  def self.for(character)
    @@character_map[character]
  end

  def handle_join(character)
    @@character_map[character] = self
  end

  def handle_leave(character)
    @@character_map[character] = nil
  end
end