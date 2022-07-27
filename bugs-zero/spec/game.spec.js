require('../game.js');

describe("The test environment", function() {
  it("should access game", function() {
    expect(Game).toBeDefined();
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

  it("does not allow <2 players", () => {
    const playerNames = ["bob"]
    expect(() => new Game({ playerNames })).toThrow("Game should have 2 to 6 players.");
  });

  it("does not allow >6 players", () => {
    const playerNames = ["bob", "bob1", "bob2", "bob3", "bob4", "bob5", "bob6"];
    expect(() => new Game({ playerNames })).toThrow("Game should have 2 to 6 players.");
  });
});

describe("roll", function() {
  describe("with player in penalty box", () => {
    var game;
    beforeEach(() => {
      game = new Game({ playerNames: ["bob", "alice"] });
      game.wrongAnswer(); // bob in penalty, current player becomes alice
      game.wrongAnswer(); // alice in penalty, current player becomes bob
    });

    it("does not change current player", () => {
      game.roll(1);
      expect(game.currentPlayerState().player.name).toEqual("bob");
      game.roll(2);
      expect(game.currentPlayerState().player.name).toEqual("bob");
    });

    it("cannot get out when rolling an even number", () => {
      game.roll(2);
      const currentPlayer = game.currentPlayerState().player;
      expect(currentPlayer.inPenaltyBox).toEqual(true);
      expect(game.currentPlayerState().isGettingOutOfPenaltyBox).toEqual(false);
    });

    it("does not askQuestion when rolling an even number", () => {
      game.roll(2);
      expect(game.questionBank().totalRemaining).toEqual(200);
    });

    it("does not change player place when rolling an even number", () => {
      game.roll(2);
      const currentPlayer = game.currentPlayerState().player;
      expect(currentPlayer.name).toEqual("bob");
      expect(currentPlayer.place).toEqual(0);
    });

    it("can get out when rolling an odd number", () => {
      game.roll(1);
      const currentPlayer = game.currentPlayerState().player;
      expect(currentPlayer.inPenaltyBox).toEqual(true);
      expect(game.currentPlayerState().isGettingOutOfPenaltyBox).toEqual(true);
    });

    it("askQuestion when rolling an odd number", () => {
      game.roll(1);
      expect(game.questionBank().totalRemaining).toEqual(199);
    });

    it("increments player place by the rolled number when odd", () => {
      game.roll(1);
      game.roll(1);
      const currentPlayer = game.currentPlayerState().player;
      expect(currentPlayer.place).toEqual(2);
    });

    it("normalises player place within 0 to 11", () => {
      game.roll(11);
      game.roll(1);
      const currentPlayer = game.currentPlayerState().player;
      expect(currentPlayer.place).toEqual(0);
    });
  });
  describe("when player is not in penalty box", () => {
    var game;
    beforeEach(() => {
      game = new Game({ playerNames: ["bob", "alice"] });
      expect(game.getPlayers()[0].inPenaltyBox).toEqual(false);
    });

    it("does not change current player", () => {
      game.roll(1);
      expect(game.currentPlayerState().player.name).toEqual("bob");
      game.roll(2);
      expect(game.currentPlayerState().player.name).toEqual("bob");
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
      game.wrongAnswer(); // this changes the currentPlayer from alice to bob
      expect(game.currentPlayerState().isGettingOutOfPenaltyBox).toEqual(false);
    });

    it("changes currentPlayer", () => {
      game.wasCorrectlyAnswered();
      expect(game.currentPlayerState().player.name).toEqual("alice");
    });

    it("does not increase the player's purse", () => {
      game.wasCorrectlyAnswered();
      expect(game.getPlayers()[0].purse).toEqual(0);
    });
  });
  describe("with player in penalty box but getting out", () => {
    var game;
    beforeEach(() => {
      game = new Game({ playerNames: ["bob", "alice"] });
      game.wrongAnswer(); // this changes the currentPlayer from bob to alice
      game.wrongAnswer(); // this changes the currentPlayer from alice to bob
      game.roll(1);
      expect(game.currentPlayerState().isGettingOutOfPenaltyBox).toEqual(true);
    });

    it("changes currentPlayer", () => {
      game.wasCorrectlyAnswered();
      expect(game.currentPlayerState().player.name).toEqual("alice");
    });

    it("increases the player's purse", () => {
      game.wasCorrectlyAnswered();
      expect(game.getPlayers()[0].purse).toEqual(1);
    });

    it("returns true if player does not win", () => {
      const result = game.wasCorrectlyAnswered();
      expect(result).toEqual(true);
    });

    // difficult to test now :/
    // it("returns false if player wins", () => {
    //   const result = game.wasCorrectlyAnswered();
    //   expect(result).toEqual(false);
    // });
  });
});
