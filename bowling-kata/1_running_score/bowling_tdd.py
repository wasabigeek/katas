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

  def traverse_rolls(self, traverser):
    roll_index = 0
    for frame in range(0, 9):
      if self._is_strike(roll_index):
        traverser.strike_fn(roll_index, self)
        roll_index += 1
      elif self._is_spare(roll_index):
        traverser.spare_fn(roll_index, self)
        roll_index += 2
      else:
        traverser.normal_fn(roll_index, self)
        roll_index += 2
    traverser.final_frame_fn(roll_index, self)

  def _get_index(self, index):
    return self._rolls[index]

  def _get_roll_score(self, index):
    if len(self._rolls) < index + 1:  # prevent IndexError, should only be possible on the last frame
      return 0
    if self._get_index(index) is None:  # unrolled
      return 0
    return self._get_index(index)

  def _is_spare(self, roll_index):
    return (self._get_roll_score(roll_index) + self._get_roll_score(roll_index + 1)) == 10

  def _is_strike(self, roll_index):
    return self._get_roll_score(roll_index) == 10

class Scorer:
  def __init__(self) -> None:
    self.score = 0

  def strike_fn(self, roll_index, rolls):
    self.score += 10 + rolls.sum_rolled_scores(roll_index + 1, roll_index + 2)

  def spare_fn(self, roll_index, rolls):
    self.score += 10 + rolls.sum_rolled_scores(roll_index + 2, roll_index + 2)

  def normal_fn(self, roll_index, rolls):
    self.score += rolls.sum_rolled_scores(roll_index, roll_index + 1)

  def final_frame_fn(self, roll_index, rolls):
    self.score += rolls.sum_rolled_scores(roll_index, roll_index + 2)

class FrameDataGenerator:
  def __init__(self) -> None:
    self.data = []

  def strike_fn(self, roll_index, rolls):
    frame_rolls = rolls.get_rolled_rolls(roll_index, roll_index)
    frame_score = None
    bonus_score = rolls.sum_rolled_scores(roll_index, roll_index + 2)
    if bonus_score:
      frame_score = bonus_score

    self.data.append({
      "rolls": frame_rolls,
      "score": frame_score
    })

  def spare_fn(self, roll_index, rolls):
    frame_rolls = rolls.get_rolled_rolls(roll_index, roll_index + 1)
    frame_score = None
    if len(frame_rolls) == 2:
      frame_score = rolls.sum_rolled_scores(roll_index, roll_index + 2)

    self.data.append({
      "rolls": frame_rolls,
      "score": frame_score
    })

  def normal_fn(self, roll_index, rolls):
    frame_rolls = rolls.get_rolled_rolls(roll_index, roll_index + 1)
    self.data.append({
      "rolls": frame_rolls,
      "score": rolls.sum_rolled_scores(roll_index, roll_index + 1) if len(frame_rolls) == 2 else None
    })

  def final_frame_fn(self, roll_index, rolls):
    frame_rolls = rolls.get_rolled_rolls(roll_index, roll_index + 2)
    self.data.append({
      "rolls": frame_rolls,
      "score": rolls.sum_rolled_scores(roll_index, roll_index + 2) if len(frame_rolls) >= 2 else None
    })

class Game:
  def __init__(self) -> None:
    self.rolls = Rolls()

  def roll(self, pins):
    self.rolls.add(pins)

  def score(self):
    scorer = Scorer()
    self.rolls.traverse_rolls(scorer)
    return scorer.score

  def frames_data(self):
    data_generator = FrameDataGenerator()
    self.rolls.traverse_rolls(data_generator)
    return data_generator.data

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

  def test_perfect_game(self):
    self.roll_many(12, 10)
    self.assertEqual(
      [
        { "rolls": [10], "score": 30 },
        { "rolls": [10], "score": 30 },
        { "rolls": [10], "score": 30 },
        { "rolls": [10], "score": 30 },
        { "rolls": [10], "score": 30 },
        { "rolls": [10], "score": 30 },
        { "rolls": [10], "score": 30 },
        { "rolls": [10], "score": 30 },
        { "rolls": [10], "score": 30 },
        { "rolls": [10, 10, 10], "score": 30 },
      ],
      self.game.frames_data()
    )

if __name__ == '__main__':
    unittest.main()
