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
    });

    it("returns false when rolling an even number", () => {
      const result = game.roll(2);
      expect(result).toEqual(false);
    });

    it("does not askQuestion when rolling an even number", () => {
      game.roll(2);
      expect(game.questionBank().askedCount()).toEqual(0);
    });

    it("does not change player place when rolling an even number", () => {
      game.roll(2);
      const currentPlayer = game.currentPlayerState().player;
      expect(currentPlayer.name).toEqual("bob");
      expect(currentPlayer.place).toEqual(0);
    });

    it("gets out of penalty box when rolling an odd number", () => {
      game.roll(1);
      const currentPlayer = game.currentPlayerState().player;
      expect(currentPlayer.inPenaltyBox).toEqual(false);
    });

    it("returns true when rolling an odd number", () => {
      const result = game.roll(1);
      expect(result).toEqual(true);
    });

    it("askQuestion when rolling an odd number", () => {
      game.roll(1);
      expect(game.questionBank().askedCount()).toEqual(1);
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
      expect(game.questionBank().askedCount()).toEqual(1);
      game.roll(2);
      expect(game.questionBank().askedCount()).toEqual(2);
    });

    it("returns true regardless of even or odd number", () => {
      expect(game.roll(1)).toEqual(true);
      expect(game.roll(2)).toEqual(true);
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

describe("progressPlayer", () => {
  var game;
  beforeEach(() => {
    game = new Game({ playerNames: ["bob", "alice"] });
  });

  it("changes currentPlayer", () => {
    game.progressPlayer();
    expect(game.currentPlayerState().player.name).toEqual("alice");
  });
});

describe("wasCorrectlyAnswered", () => {
  describe("with player in penalty box", () => {
    var game;
    beforeEach(() => {
      game = new Game({ playerNames: ["bob", "alice"] });
      game.wrongAnswer(); // workaround to put bob in penalty
    });

    it("does not increase the player's purse", () => {
      game.wasCorrectlyAnswered();
      expect(game.getPlayers()[0].purse).toEqual(0);
    });
  });
  describe("with player not in penalty box", () => {
    var game;
    beforeEach(() => {
      game = new Game({ playerNames: ["bob", "alice"] });
    });

    it("increases the player's purse", () => {
      game.wasCorrectlyAnswered();
      expect(game.getPlayers()[0].purse).toEqual(1);
    });
  });
});

describe("didPlayerWin", () => {
  it("returns false if current player does not have enough coins", () => {
    game = new Game({ playerNames: ["bob", "alice"], amountToWin: 1 });
    expect(game.didPlayerWin()).toEqual(false);
  });

  it("returns true if current player has enough coins", () => {
    game = new Game({ playerNames: ["bob", "alice"], amountToWin: 1 });
    game.wasCorrectlyAnswered();
    expect(game.didPlayerWin()).toEqual(true);
  });
});
