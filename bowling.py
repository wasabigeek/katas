class Frame:
    """
    Knowledge of when a frame is done and what rolls are in the frame
    """
    def __init__(self, is_final=False, prev_frame=None):
        self.rolls = []
        self.is_final = is_final
        self.prev_frame = None
        self.next_frame = None

    def is_complete(self):
        # spare or normal
        if not self.is_final: # I guess this is why uncle bob introduces a new class
            if len(self.rolls) >= 2:
                return True
            if self._is_strike():
                return True
        else:
            if self._is_spare() and len(self.rolls) >= 3:
                return True
            if self._is_strike() and len(self.rolls) >= 2:
                return True

        return False

    def add_roll(self, pin_count):
        self.rolls.append(pin_count)

    def base_score(self):
        score = 0
        for roll in self.rolls:
            score += roll
        return score

    def bonus_score(self):
        if self.is_final:
            if len(self.rolls) < 3:
                return 0
            elif self.rolls[0] == 10:
                return self.rolls[1] + self.rolls[2]
            elif self.rolls[1] == 10 or (self.rolls[0] + self.rolls[1] == 10):
                return self.rolls[2]

        if self.next_frame is None:
            return 0

        if self._is_spare() and len(self.next_frame.rolls) > 0:
            return self.next_frame.rolls[0]

        if self._is_strike() and len(self.next_frame.rolls) > 0:
            # FIXME: IndexError if next_frame only has one roll
            return self.next_frame.rolls[0] + self.next_frame.rolls[1]

        return 0

    def __str__(self):
        return "<Frame rolls={rolls}>".format(rolls=self.rolls)

    # TODO: these aren't precise enough for the final frame
    def _is_strike(self):
        return self.rolls and self.rolls[0] == 10

    def _is_spare(self):
        return len(self.rolls) > 1 and (self.rolls[0] + self.rolls[1] == 10)


class BowlingGame:
    def __init__(self):
        self.current_frame = Frame()
        self.frames = [self.current_frame]

    def roll(self, pin_count):
        self.current_frame.add_roll(pin_count)
        if self.current_frame.is_complete() and len(self.frames) < 10:
            is_final_frame = len(self.frames) == 9
            new_frame = Frame(is_final=is_final_frame, prev_frame=self.current_frame)
            self.current_frame.next_frame = new_frame
            self.current_frame = new_frame
            self.frames.append(new_frame)

    def score(self):
        score = 0
        for frame in self.frames:
            score += frame.base_score()
            score += frame.bonus_score()
        return score


game = BowlingGame()
game.roll(2)
assert len(game.frames) == 1
assert game.score() == 2

# test spare
game.roll(8)
assert len(game.frames) == 2
assert game.score() == 10

game.roll(5)
assert len(game.frames) == 2
assert game.score() == 20  # next roll after spare is doubled

game.roll(1)
assert len(game.frames) == 3
assert game.score() == 21

# strike
game.roll(10)
assert len(game.frames) == 4
assert game.score() == 31

# 2 rolls after strike are doubled
game.roll(3)
game.roll(4)
assert len(game.frames) == 5
assert game.score() == 45

# spare in final frame
game = BowlingGame()
for i in range(0, 9):
    game.roll(3)
    game.roll(5)
assert game.score() == 72
game.roll(5)
game.roll(5)
game.roll(5)
assert game.score() == 92
assert len(game.frames) == 10

