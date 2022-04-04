import unittest

class Game:
  def __init__(self) -> None:
    self._score = 0

  def roll(self, pins):
    self._score += pins

  def score(self):
    return self._score

class TestBowlingGame(unittest.TestCase):
  def test_gutter_game(self):
    game = Game()
    for i in range(0, 20):
      game.roll(0)
    self.assertEqual(0, game.score())

  def test_all_ones(self):
    game = Game()
    for i in range(0, 20):
      game.roll(1)
    self.assertEqual(20, game.score())

if __name__ == '__main__':
    unittest.main()
