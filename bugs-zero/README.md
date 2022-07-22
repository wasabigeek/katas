# Bugs Zero Kata
https://kata-log.rocks/bugs-zero-kata

## What is the task?
[Trivia](https://github.com/caradojo/trivia) from the legacy code retreat is a good codebase to start this with. There are a few bugs in the code and a few weaknesses in the design to fix. By a weakness we mean that it’d be easy for a developer to introduce a certain type of bug while working with the code. Your job is to change the design so that it is either impossible or at least much less likely that that kind of bug would be introduced.

## Where to start?
Pick any of the listed problems
- A Game could have less than two players - make sure it always has at least two.
	- Use a compiled language or a static type checker like flowtype
- A Game could have 7 players, make it have at most 6.
	- or slightly easier allow for 7 players or more
- A player that get’s into prison always stays there
	- Other than just fixing the bug, try to understand what’s wrong with the design and fix the root cause
- The deck could run out of questions
- 	Make sure that can’t happen (a deck with 1 billion questions is cheating :)
- Introducing new categories of questions seems like tricky business.
	- Could you make sure all places have the “right” question and that the distribution is always correct?
- Similarly changing the board size greatly affects the questions distribution

# Setup

To run tests: `npx jasmine-node .`

Any test source matching the pattern *.spec.js will be executed.
