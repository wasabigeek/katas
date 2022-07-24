require('../game.js');

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

describe("new", function() {
  it("correctly adds players", () => {
    const playerNames = ["bob", "alice"];
    const game = new Game({ playerNames });
    expect(game.getPlayers().length).toEqual(2);
    game.getPlayers().forEach((player) => {
      expect(player.place).toEqual(0);
      expect(player.purse).toEqual(0);
    });
  });

  it("does not allow >6 players", () => {
    const playerNames = ["bob", "bob1", "bob2", "bob3", "bob4", "bob5", "bob6"];
    expect(() => new Game({ playerNames })).toThrow("Game should have 6 or less players.");
  });
});

describe("roll", function() {
  describe("with player in penalty box", () => {
    var game;
    beforeEach(() => {
      game = new Game({ playerNames: ["bob"] });
      game.wrongAnswer();
      expect(game.currentPlayerState().player.inPenaltyBox).toEqual(true);
    });

    it("cannot get out when rolling an even number", () => {
      game.roll(2);
      expect(game.currentPlayerState().player.inPenaltyBox).toEqual(true);
      expect(game.currentPlayerState().isGettingOutOfPenaltyBox).toEqual(false);
    });

    it("does not askQuestion when rolling an even number", () => {
      game.roll(2);
      expect(game.questionBank().totalRemaining).toEqual(200);
    });

    it("does not change player place when rolling an even number", () => {
      game.roll(2);
      expect(game.currentPlayerState().player.place).toEqual(0);
    });

    it("can get out when rolling an odd number", () => {
      game.roll(1);
      expect(game.currentPlayerState().player.inPenaltyBox).toEqual(true);
      expect(game.currentPlayerState().isGettingOutOfPenaltyBox).toEqual(true);
    });

    it("askQuestion when rolling an odd number", () => {
      game.roll(1);
      expect(game.questionBank().totalRemaining).toEqual(199);
    });

    it("increments player place by the rolled number when odd", () => {
      game.roll(1);
      game.roll(1);
      expect(game.currentPlayerState().player.place).toEqual(2);
    });

    it("normalises player place within 0 to 11", () => {
      game.roll(11);
      game.roll(1);
      expect(game.currentPlayerState().player.place).toEqual(0);
    });
  });
  describe("when player is not in penalty box", () => {
    var game;
    beforeEach(() => {
      game = new Game({ playerNames: ["bob"] });
      expect(game.currentPlayerState().player.inPenaltyBox).toEqual(false);
    });

    it("askQuestion regardless of even or odd number", () => {
      game.roll(1);
      expect(game.questionBank().totalRemaining).toEqual(199);
      game.roll(2);
      expect(game.questionBank().totalRemaining).toEqual(198);
    });

    it("increments player place by the rolled number", () => {
      game.roll(1);
      game.roll(2);
      expect(game.currentPlayerState().player.place).toEqual(3);
    });

    it("normalises player place within 0 to 11", () => {
      game.roll(11);
      game.roll(1);
      expect(game.currentPlayerState().player.place).toEqual(0);
    });
  });
});

describe("wasCorrectlyAnswered", () => {
  describe("with player in penalty box but not getting out", () => {
    var game;
    beforeEach(() => {
      game = new Game({ playerNames: ["bob", "alice"] });
      game.wrongAnswer(); // this changes the currentPlayer from bob to alice
    });

    it("changes currentPlayer", () => {
      game.wasCorrectlyAnswered();
      expect(game.currentPlayerState().player.name).toEqual("bob");
    });
  });
});
