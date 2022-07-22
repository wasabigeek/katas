require('./game.js');

describe("The test environment", function() {
  it("should pass", function() {
    expect(true).toBe(true);
  });

  it("should access game", function() {
    expect(Game).toBeDefined();
  });
});

describe("add", function() {
  it("correctly increases number of players", () => {
    const game = new Game();
    expect(game.howManyPlayers()).toEqual(0);
    game.add("bob");
    expect(game.howManyPlayers()).toEqual(1);
  });

  it("does not allow >6 players", () => {
    const game = new Game();
    for (var i = 0; i < 6; i++) {
      game.add(`bob${i}`);
    }
    expect(game.howManyPlayers()).toEqual(6);
    game.add("alice");
    expect(game.howManyPlayers()).toEqual(6);
  });
});
