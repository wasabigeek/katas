import pdb
import unittest

class Rolls:
  def __init__(self):
    self._rolls = [None for i in range(0, 20)]
    self.current_roll = 0

  def add(self, pins):
    self._rolls[self.current_roll] = pins
    self.current_roll += 1

  def get_rolled_rolls(self, start_index, end_index):
    return list(filter(
      lambda roll: roll is not None,
      self._rolls[start_index:end_index + 1]
    ))

  def sum_rolled_scores(self, start_index, end_index):
    sum = 0
    for i in range(start_index, end_index + 1):
      sum += self._get_roll_score(i)
    return sum

  def traverse_rolls(self, strike_fn, spare_fn, normal_fn):
    roll_index = 0
    for frame in range(0, 10):
      if self._is_strike(roll_index):
        strike_fn(roll_index)
        roll_index += 1
      elif self._is_spare(roll_index):
        spare_fn(roll_index)
        roll_index += 2
      else:
        normal_fn(roll_index)
        roll_index += 2

  def _get_index(self, index):
    return self._rolls[index]

  def _get_roll_score(self, index):
    # if len(self.rolls) < index + 1:  # prevent IndexError, should only be possible on the last frame
    #   return 0
    if self._get_index(index) is None:  # unrolled
      return 0
    return self._get_index(index)

  def _is_spare(self, roll_index):
    return (self._get_roll_score(roll_index) + self._get_roll_score(roll_index + 1)) == 10

  def _is_strike(self, roll_index):
    return self._get_roll_score(roll_index) == 10

class Game:
  def __init__(self) -> None:
    self.rolls = Rolls()

  def roll(self, pins):
    self.rolls.add(pins)

  def score(self):
    score = 0
    def strike_fn(roll_index):
      nonlocal score
      score += 10 + self.rolls.sum_rolled_scores(roll_index + 1, roll_index + 2)
    def spare_fn(roll_index):
      nonlocal score
      score += 10 + self.rolls.sum_rolled_scores(roll_index + 2, roll_index + 2)
    def normal_fn(roll_index):
      nonlocal score
      score += self.rolls.sum_rolled_scores(roll_index, roll_index + 1)

    self.rolls.traverse_rolls(
      strike_fn,
      spare_fn,
      normal_fn
    )

    return score

  def frames_data(self):
    data = []
    def strike_fn(roll_index):
      nonlocal data
      frame_rolls = self.rolls.get_rolled_rolls(roll_index, roll_index)
      frame_score = None
      bonus_score = self.rolls.sum_rolled_scores(roll_index, roll_index + 2)
      if bonus_score:
        frame_score = bonus_score

      data.append({
        "rolls": frame_rolls,
        "score": frame_score
      })

    def spare_fn(roll_index):
      nonlocal data
      frame_rolls = self.rolls.get_rolled_rolls(roll_index, roll_index + 1)
      frame_score = None
      if len(frame_rolls) == 2:
        frame_score = self.rolls.sum_rolled_scores(roll_index, roll_index + 2)

      data.append({
        "rolls": frame_rolls,
        "score": frame_score
      })

    def normal_fn(roll_index):
      nonlocal data
      frame_rolls = self.rolls.get_rolled_rolls(roll_index, roll_index + 1)
      data.append({
        "rolls": frame_rolls,
        "score": self.rolls.sum_rolled_scores(roll_index, roll_index + 1) if len(frame_rolls) == 2 else None
      })

    self.rolls.traverse_rolls(
      strike_fn,
      spare_fn,
      normal_fn
    )
    return data

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
    self.roll_many(3, 3)
    self.assertEqual(
      [
        { "rolls": [3, 3], "score": 6 },
        { "rolls": [3], "score": None },
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

  def test_spare(self):
    self.roll_spare()
    self.game.roll(3)
    self.assertEqual(
      [
        { "rolls": [5, 5], "score": 13 },
        { "rolls": [3], "score": None },
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

  def test_strike(self):
    self.roll_strike()
    self.game.roll(3)
    self.game.roll(4)
    self.assertEqual(
      [
        { "rolls": [10], "score": 17 },
        { "rolls": [3, 4], "score": 7 },
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
