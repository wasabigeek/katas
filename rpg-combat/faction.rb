# frozen_string_literal: true

require 'set'

class Faction
  @@character_map = Hash.new { |hash, key| hash[key] = Set.new }

  def self.for(character)
    @@character_map[character]
  end

  def self.allies?(character1, character2)
    (self.for(character1) & self.for(character2)).any?
  end

  def handle_join(character)
    @@character_map[character] << self
  end

  def handle_leave(character)
    @@character_map[character].delete(self)
  end
end
