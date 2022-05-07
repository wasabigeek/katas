For "TDD", I delayed creating new objects.

Observations on the current design:
- Leaned towards modularizing code by the function (e.g. scoring, generating data) instead of the "concept", something like the visitor pattern.
  - The scoring and frame data generation logic turned out to be quite coupled (surprise!) since the FrameData also needs to calculate the score. I could extract the scoring logic such that they're shared of course, but it feels like it might be additional complexity.
  - That said, all these changes didn't require updating the Game once that was refactored to a visitor-like pattern. And it should be easier to add new traversers? Though I think it wouldn't be too hard to do similarly in the OOP design.
- As I could compare the design side-by-side, this felt like I was digging myself further into a ditch :( Pretty sure I was subconsciously trying to avoid the same design though, so not sure if I would have refactored the TDD design in a vacuum.
