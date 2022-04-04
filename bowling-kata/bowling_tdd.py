import unittest

class Game:
  def roll(self, pins):
    pass

class TestBowlingGame(unittest.TestCase):
  def test_gutter_game(self):
    game = Game()
    for i in range(0, 20):
      game.roll(0)

if __name__ == '__main__':
    unittest.main()
