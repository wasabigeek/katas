import pdb
import unittest

class Rolls:
  def __init__(self):
    self._rolls = [None for i in range(0, 20)]
    self.current_roll = 0

  def add(self, pins):
    self._rolls[self.current_roll] = pins
    self.current_roll += 1

  def traverse_rolls(self, traverser):
    roll_index = 0
    for frame in range(0, 9):
      if self._is_strike(roll_index):
        traverser.on_strike_frame(
          frame_rolls=self._get_rolled(roll_index, roll_index),
          trailing_rolls=self._get_rolled(roll_index + 1, roll_index + 2)
        )
        roll_index += 1
      elif self._is_spare(roll_index):
        traverser.on_spare_frame(
          frame_rolls=self._get_rolled(roll_index, roll_index + 1),
          trailing_rolls=self._get_rolled(roll_index + 2, roll_index + 3)
        )
        roll_index += 2
      else:
        traverser.on_normal_frame(
          frame_rolls=self._get_rolled(roll_index, roll_index + 1),
          trailing_rolls=self._get_rolled(roll_index + 2, roll_index + 3)
        )
        roll_index += 2

    traverser.on_final_frame(
      frame_rolls=self._get_rolled(roll_index, roll_index + 2),
      trailing_rolls=[]
    )

  def _get_index(self, index):
    return self._rolls[index]

  def _get_rolled(self, start_index, end_index):
    return list(filter(
      lambda roll: roll is not None,
      self._rolls[start_index:end_index + 1]
    ))

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
  @classmethod
  def score_strike_frame(cls, frame_rolls, trailing_rolls):
    score = None
    if len(trailing_rolls) > 0:
      score = 10
      for roll in trailing_rolls[0:2]:
        score += roll
    return score

class ScoreVisitor:
  def __init__(self) -> None:
    self.score = 0

  def on_strike_frame(self, frame_rolls, trailing_rolls):
    # Note: score_strike_frame can return None :/
    self.score += Scorer.score_strike_frame(frame_rolls, trailing_rolls)

  def on_spare_frame(self, frame_rolls, trailing_rolls):
    self.score += 10
    if len(trailing_rolls) > 0:
      self.score += trailing_rolls[0]

  def on_normal_frame(self, frame_rolls, trailing_rolls):
    for roll in frame_rolls:
      self.score += roll

  def on_final_frame(self, frame_rolls, trailing_rolls):
    self.on_normal_frame(frame_rolls, trailing_rolls)

class FrameDataVisitor:
  def __init__(self) -> None:
    self.data = []

  def on_strike_frame(self, frame_rolls, trailing_rolls):
    self.data.append({
      "rolls": frame_rolls,
      "score": Scorer.score_strike_frame(frame_rolls, trailing_rolls)
    })

  def on_spare_frame(self, frame_rolls, trailing_rolls):
    frame_score = None
    if len(trailing_rolls) > 0:
      frame_score = 10 + trailing_rolls[0]

    self.data.append({
      "rolls": frame_rolls,
      "score": frame_score
    })

  def on_normal_frame(self, frame_rolls, trailing_rolls):
    frame_score = None
    if len(frame_rolls) == 2:
      frame_score = 0
      for roll in frame_rolls:
        frame_score += roll

    self.data.append({
      "rolls": frame_rolls,
      "score": frame_score
    })

  def on_final_frame(self, frame_rolls, trailing_rolls):
    frame_score = None
    if self._final_frame_is_complete(frame_rolls):
      frame_score = 0
      for roll in frame_rolls:
        frame_score += roll

    self.data.append({
      "rolls": frame_rolls,
      "score": frame_score
    })

  def _final_frame_is_complete(self, frame_rolls):
    # strike/spare, or regular completion via 2 rolls
    return (sum(frame_rolls[0:1]) >= 10 and len(frame_rolls) >= 3) or \
      len(frame_rolls) == 2

class Game:
  def __init__(self) -> None:
    self.rolls = Rolls()

  def roll(self, pins):
    self.rolls.add(pins)

  def score(self):
    scorer = ScoreVisitor()
    self.rolls.traverse_rolls(scorer)
    return scorer.score

  def frames_data(self):
    data_generator = FrameDataVisitor()
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
