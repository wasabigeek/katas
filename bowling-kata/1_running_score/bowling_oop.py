import unittest


class Frame:
    """
    Knowledge of when a frame is done and what rolls are in the frame
    """
    def __init__(self):
        self.rolls = []
        # this seems like an opportunity for a iterator / python generator
        self.next_frame = None

    def is_complete(self):
        raise NotImplementedError

    def add_roll(self, pin_count):
        self.rolls.append(pin_count)

    def score(self):
        return self._base_score() + self._bonus_score()

    def walk_by_rolls(self, num_rolls):
        """
        Get the next num_rolls rolls from this and following frames, if any. Useful for calculating bonus scores.
        Note: one key assumption here is that you only start from a frame (as opposed to a roll), which happens to work OK in bowling.
        """
        if num_rolls <= 0:
            return []

        if num_rolls >= len(self.rolls):
            recursed_rolls = list(self.rolls)
            if self.next_frame is not None:
                recursed_rolls += self.next_frame.walk_by_rolls(num_rolls - len(self.rolls))

            return recursed_rolls
        else:
            return self.rolls[:num_rolls]

    def _base_score(self):
        score = 0
        for roll in self.rolls:
            score += roll
        return score

    def _bonus_score(self):
        raise NotImplementedError

    def __str__(self):
        return "<Frame rolls={rolls}>".format(rolls=self.rolls)

class NormalFrame(Frame):
    def is_complete(self):
        if len(self.rolls) >= 2:
            return True
        if self._is_strike():
            return True

        return False

    def _bonus_score(self):
        num_bonus_rolls = 0
        if self._is_spare():
            num_bonus_rolls = 1
        elif self._is_strike():
            num_bonus_rolls = 2

        score = 0
        for roll in self.next_frame.walk_by_rolls(num_bonus_rolls): # assumes all frames already created by the time this is called
            score += roll
        return score

    def _is_strike(self):
        return self.rolls and self.rolls[0] == 10

    def _is_spare(self):
        return len(self.rolls) > 1 and (self.rolls[0] + self.rolls[1] == 10)

class FinalFrame(Frame):
    def is_complete(self):
        if len(self.rolls) >= 3:
            return True
        elif len(self.rolls) == 2 and (self.rolls[0] + self.rolls[1] < 10):
            return True

        return False

    def _bonus_score(self):
        return 0


class BowlingGame:
    def __init__(self):
        self.root_frame = NormalFrame()
        cursor = self.root_frame
        for i in range(0, 8):
            new_frame = NormalFrame()
            cursor.next_frame = new_frame
            cursor = new_frame
        cursor.next_frame = FinalFrame()

        # TODO: remove after refactor?
        self._current_frame = self.root_frame
        self.current_frame = NormalFrame()
        self.frames = [self.current_frame]

    def roll(self, pin_count):
        self._current_frame.add_roll(pin_count)
        if self._current_frame.is_complete():
            self._current_frame = self._current_frame.next_frame

        self.current_frame.add_roll(pin_count)
        if self.current_frame.is_complete() and len(self.frames) < 10:
            is_final_frame = len(self.frames) == 9
            if is_final_frame:
                new_frame = FinalFrame()
            else:
                new_frame = NormalFrame()
            self.current_frame.next_frame = new_frame
            self.current_frame = new_frame
            self.frames.append(new_frame)

    def score(self):
        score = 0
        cursor_frame = self.root_frame

        while True:
            score += cursor_frame.score()
            cursor_frame = cursor_frame.next_frame
            if cursor_frame is None:
                break

        # for frame in self.frames:
        #     score += frame.score()
        return score

    def frames_data(self):
        return [
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
        ]

class TestBowlingGame(unittest.TestCase):
  def setUp(self):
    self.game = BowlingGame()
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

  def test_spare_in_last_frame(self):
    self.roll_many(18, 0)
    self.roll_spare()
    self.game.roll(4)
    self.assertEqual(14, self.game.score())

class TestBowlingGameScorecard(unittest.TestCase):
  def setUp(self):
    self.game = BowlingGame()
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

  # def test_partial_frame(self):
  #   self.roll_many(3, 3)
  #   self.assertEqual(
  #     [
  #       { "rolls": [3, 3], "score": 6 },
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
