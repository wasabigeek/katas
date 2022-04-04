import unittest

class Game:
  def __init__(self) -> None:
    self._score = 0

  def roll(self, pins):
    self._score += pins

  def score(self):
    return self._score

class TestBowlingGame(unittest.TestCase):
  def setUp(self):
    self.game = Game()
    return super().setUp()

  def roll_many(self, rolls, pins):
    for i in range(0, rolls):
      self.game.roll(pins)

  def test_gutter_game(self):
    self.roll_many(20, 0)
    self.assertEqual(0, self.game.score())

  def test_all_ones(self):
    self.roll_many(20, 1)
    self.assertEqual(20, self.game.score())

  def test_one_spare(self):
    self.game.roll(5)
    self.game.roll(5) # spare
    self.game.roll(3)
    self.roll_many(17, 0)
    self.assertEqual(16, self.game.score())

if __name__ == '__main__':
    unittest.main()
