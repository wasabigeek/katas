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
    expect(game.getPlayers().length).toEqual(6);
    result = game.add("alice");
    expect(result).toEqual(false);
    expect(game.getPlayers().length).toEqual(6);
  });
});

describe("roll", function() {
  describe("with player in penalty box", () => {
    it("cannot get out when rolling an even number", () => {
      const game = new Game();
      game.add("bob");
      game.wrongAnswer();
      expect(game.currentPlayerState().player.inPenaltyBox).toEqual(true);

      game.roll(2);
      expect(game.currentPlayerState().player.inPenaltyBox).toEqual(true);
      expect(game.currentPlayerState().isGettingOutOfPenaltyBox).toEqual(false);
    });

    it("can get out when rolling an odd number", () => {
      const game = new Game();
      game.add("bob");
      game.wrongAnswer();
      expect(game.currentPlayerState().player.inPenaltyBox).toEqual(true);

      game.roll(1);
      expect(game.currentPlayerState().player.inPenaltyBox).toEqual(true);
      expect(game.currentPlayerState().isGettingOutOfPenaltyBox).toEqual(true);
    });
  });
});

describe("wasCorrectlyAnswered", () => {

})
