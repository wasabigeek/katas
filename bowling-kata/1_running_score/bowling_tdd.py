import pdb
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
    roll_index = 0
    for frame in range(0, 10):
      if self._is_strike(roll_index):
        score += 10 + self._get_roll_score(roll_index + 1) + self._get_roll_score(roll_index + 2)
        roll_index += 1
      elif self._is_spare(roll_index):
        score += 10 + self._get_roll_score(roll_index + 2)
        roll_index += 2
      else:
        score += self._get_roll_score(roll_index) + self._get_roll_score(roll_index + 1)
        roll_index += 2

    return score

  def frames_data(self):
    data = []
    roll_index = 0
    for frame in range(0, 10):
      if self._is_strike(roll_index):
        # TODO
        roll_index += 1
      elif self._is_spare(roll_index):
        # TODO
        roll_index += 2
      else:
        frame_rolls = list(filter(
          lambda roll: roll is not None,
          [self.rolls[roll_index], self.rolls[roll_index + 1]]
        ))
        frame_data = {
          "rolls": frame_rolls,
          "score": self._get_roll_score(roll_index) + self._get_roll_score(roll_index + 1) if len(frame_rolls) == 2 else None
        }
        roll_index += 2

      data.append(frame_data)

    return data

    # for frame in range(0, 10):
    #   frame_data = {
    #     "rolls": [],
    #     "score": None
    #   }
    #   if self.rolls[roll_index] is not None:
    #     frame_data["rolls"].append(self.rolls[roll_index])
    #   if self.rolls[roll_index + 1] is not None:
    #     frame_data["rolls"].append(self.rolls[roll_index + 1])

    #   if self.rolls[roll_index] and self.rolls[roll_index + 1]:
    #     if self._is_spare(roll_index):
    #       if self.rolls[roll_index + 2]:
    #         frame_data["score"] = self.rolls[roll_index] + self.rolls[roll_index] + self.rolls[roll_index + 2]
    #       # note: skips scoring if there not enough info to calculate score yet
    #     # normal roll
    #     else:
    #       frame_data["score"] = self.rolls[roll_index] + self.rolls[roll_index]


    #   data.append(frame_data)
    #   roll_index += 2

    # return data

  def _is_spare(self, roll_index):
    return (self._get_roll_score(roll_index) + self._get_roll_score(roll_index + 1)) == 10

  def _is_strike(self, roll_index):
    return self._get_roll_score(roll_index) == 10

  def _get_roll_score(self, index):
    if len(self.rolls) < index + 1:  # prevent IndexError, should only be possible on the last frame
      return 0
    if self.rolls[index] is None:  # unrolled
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

  # def test_spare(self):
  #   self.roll_spare()
  #   self.game.roll(3)
  #   self.assertEqual(
  #     [
  #       { "rolls": [5, 5], "score": 13 },
  #       { "rolls": [3], "score": None },
  #       { "rolls": [], "score": None },
  #       { "rolls": [], "score": None },
  #       { "rolls": [], "score": None },
  #       { "rolls": [], "score": None },
  #       { "rolls": [], "score": None },
  #       { "rolls": [], "score": None },
  #       { "rolls": [], "score": None },
  #       { "rolls": [], "score": None },
  #     ],
  #     self.game.frames_data()
  #   )

if __name__ == '__main__':
    unittest.main()
