import unittest

class Game:
  def __init__(self) -> None:
    self.rolls = [None for i in range(0, 20)]
    self.current_roll = 0

  def roll(self, pins):
    self.rolls[self.current_roll] = pins
    self.current_roll += 1

  def score(self):
    score = 0
    frame_index = 0
    for frame in range(0, 10):
      if self._is_strike(frame_index):
        score += 10 + self._get_roll_score(frame_index + 1) + self._get_roll_score(frame_index + 2)
        frame_index += 1
      elif self._is_spare(frame_index):
        score += 10 + self._get_roll_score(frame_index + 2)
        frame_index += 2
      else:
        score += self._get_roll_score(frame_index) + self._get_roll_score(frame_index + 1)
        frame_index += 2

    return score

  def frames_data(self):
    data = []
    for frame in range(0, 10):
      data.append({
        "rolls": [],
        "score": None
      })

    return data

  def _is_spare(self, frame_index):
    return (self._get_roll_score(frame_index) + self._get_roll_score(frame_index + 1)) == 10

  def _is_strike(self, frame_index):
    return self._get_roll_score(frame_index) == 10

  # trying my best to avoid adding new objects as an experiment
  def _get_roll_score(self, index):
    if self.rolls[index] is None:
      return 0
    return self.rolls[index]

class TestBowlingGame(unittest.TestCase):
  def setUp(self):
    self.game = Game()
    return super().setUp()

  def roll_many(self, rolls, pins):
    for i in range(0, rolls):
      self.game.roll(pins)

  def roll_spare(self):
    self.game.roll(5)
    self.game.roll(5)

  def roll_strike(self):
    self.game.roll(10)

  def test_gutter_game(self):
    self.roll_many(20, 0)
    self.assertEqual(0, self.game.score())

  def test_all_ones(self):
    self.roll_many(20, 1)
    self.assertEqual(20, self.game.score())

  def test_one_spare(self):
    self.roll_spare()
    self.game.roll(3)
    self.roll_many(17, 0)
    self.assertEqual(16, self.game.score())

  def test_one_strike(self):
    self.roll_strike()
    self.game.roll(3)
    self.game.roll(4)
    self.roll_many(16, 0)
    self.assertEqual(24, self.game.score())

  def test_perfect_game(self):
    self.roll_many(12, 10)
    self.assertEqual(300, self.game.score())

  def test_empty_game(self):
    self.assertEqual(0, self.game.score())

  # def test_spare_in_last_frame(self):
  #   self.roll_many(0, 18)
  #   self.roll_spare()
  #   self.game.roll(4)
  #   self.assertEqual(18, self.game.score())

class TestBowlingGameScorecard(unittest.TestCase):
  def setUp(self):
    self.game = Game()
    return super().setUp()

  def roll_many(self, rolls, pins):
    for i in range(0, rolls):
      self.game.roll(pins)

  def roll_spare(self):
    self.game.roll(5)
    self.game.roll(5)

  def roll_strike(self):
    self.game.roll(10)

  def test_empty_game(self):
    self.assertEqual(
      [
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
      ],
      self.game.frames_data()
    )

  def test_partial_frame(self):
    self.roll_many(1, 3)
    self.assertEqual(
      [
        { "rolls": [3], "score": 3 },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
        { "rolls": [], "score": None },
      ],
      self.game.frames_data()
    )

if __name__ == '__main__':
    unittest.main()
