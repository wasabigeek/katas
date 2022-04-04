import unittest

class Game:
  def __init__(self) -> None:
    self._score = 0
    self.rolls = [None for i in range(0, 20)]
    self.current_roll = 0

  def roll(self, pins):
    # tempted to remember previous roll in order to calculate score
    # roll calculates score although name does not imply that
    self._score += pins
    self.rolls[self.current_roll] = pins
    self.current_roll += 1

  def score(self):
    # does not calculate score although name implies that
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

  # def test_one_spare(self):
  #   self.game.roll(5)
  #   self.game.roll(5) # spare
  #   self.game.roll(3)
  #   self.roll_many(17, 0)
  #   self.assertEqual(16, self.game.score())

if __name__ == '__main__':
    unittest.main()
