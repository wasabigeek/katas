https://codingdojo.org/kata/Bowling/
https://kata-log.rocks/bowling-game-kata

## Reflections

Robert Martin's has some [slides](http://butunclebob.com/ArticleS.UncleBob.TheBowlingGameKata) on this kata. Interestingly though, they're split into two different approsches:
1. a "design session" where he breaks down the logic into multiple classes e.g. Game, Frames, Rolls.
2. the "actual" kata, where he _ignores_ all of the designed objects, instead focusing on TDD with a single Game class. (There's probably some subtext not captured in the slides alone.)

I had seen an implementation similar to the 2nd approach, but wanted to try splitting out more objects (i.e. the 1st approach). Here's some reflections on my [attempt](./bowling_oop.py):
- **The code is less concise**, and would take a new dev more reading to understand the overall logic.
- **The code is less performant**. There are a lot of extra checks - I validate if a Frame is complete before moving on, as well as prevent IndexErrors so the score could be debugged midway, _but_...
- ...one could also argue that validation is table stakes, and I think the Frame family of objects **groups this logic and makes it easier to add more in the future**. In the 2nd approach, `roll` and `score` might have to loop through all the rolls to check which frame is currently in play. (The data structure could be changed of course. At that point though, is it very different from splitting out Frame objects?)
- I'd also like to think that **some things become more obvious** e.g. it's more obvious that the FinalFrame is treated differently from a NormalFrame.
- That said, how good this design is depends on how the system grows e.g.if the bowling rules never change, the additional Frame classes might have increased complexity without improving extensibility (we'd keep using the Game class). It reminds a lot of Sandi Metz's embarassingly simple first solution to 99 bottles, and how it's very easy to create the wrong abstractions.
- Countering myself (lol), it's _possible_ for bowling rules to change in the universe of this program - it might not be for official tournament use! People like to create [variations](https://en.wikipedia.org/wiki/Bowling#Variations) after all, and this could also be for some computer game that is changes the rules wildly.

Afterward, I followed the [actual kata](./bowling_tdd.py):
- I found the TDD steps quite nice - I might not have thought to have started with a "gutter game" (all zeros) for example.
- The caveat is I think it requires a certain sense of how everything already fits together in the beginning - I'm not sure if it would be the same if it wasn't something as well-defined as bowling.
- There were some nice examples of stopping (and even reverting) to refactor when the design didn't fit the new requirement. The "code smells" were a little vague unfortunately - I think when he says "ugly", he means it doesn't reflect what it represents, what some might call "magic variables".
- There are bugs for a spare in the final frame! (see commented test)
