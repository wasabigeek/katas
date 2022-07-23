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
  it("correctly adds new players", () => {
    const game = new Game();
    expect(game.getPlayers().length).toEqual(0);

    result = game.add("bob");
    expect(result).toEqual(true);

    players = game.getPlayers()
    expect(players.length).toEqual(1);
    expect(players[0].place).toEqual(0);
    expect(players[0].purse).toEqual(0);
  });

  it("does not allow >6 players", () => {
    const game = new Game();
    for (var i = 0; i < 6; i++) {
      game.add(`bob${i}`);
    }
    expect(game.howManyPlayers()).toEqual(6);
    result = game.add("alice");
    expect(result).toEqual(true);
    expect(game.howManyPlayers()).toEqual(6);
  });
});
