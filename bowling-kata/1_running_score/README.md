For "TDD", I delayed creating new objects.

Observations on the current design:
- The FinalFrame concept is not extracted well, and may need to be considered in multiple functions (for now, only _get_roll_score, but also possibly because I've not fixed the last frame bug)
- Seems to be leaning towards modularizing code by the function (e.g. scoring, generating data) instead of the "concept". I prefer the latter, but it does feel like there will be some situations where breaking by function works better (e.g. allows for easily adding more "traversal types" a-la a visitor pattern)