exports = typeof window !== "undefined" && window !== null ? window : global;

class Player {
  constructor(place, purse, inPenaltyBox, name) {
    this.place = place;
    this.purse = purse;
    this.inPenaltyBox = inPenaltyBox;
    this.name = name;
  }
}

class QuestionBank {
  constructor() {
    this.popQuestions     = new Array();
    this.scienceQuestions = new Array();
    this.sportsQuestions  = new Array();
    this.rockQuestions    = new Array();

    for(var i = 0; i < 50; i++){
      this.popQuestions.push("Pop Question "+i);
      this.scienceQuestions.push("Science Question "+i);
      this.sportsQuestions.push("Sports Question "+i);
      this.rockQuestions.push("Rock Question "+i);
    };
  }

  shift = ({ playerPlace }) => {
    if(this.category(playerPlace) == 'Pop')
      return this.popQuestions.shift();
    if(this.category(playerPlace) == 'Science')
      return this.scienceQuestions.shift();
    if(this.category(playerPlace) == 'Sports')
      return this.sportsQuestions.shift();
    if(this.category(playerPlace) == 'Rock')
      return this.rockQuestions.shift();
  }

  totalRemaining = () => {
    return [this.popQuestions, this.scienceQuestions, this.sportsQuestions, this.rockQuestions].reduce((accum, current) => { return accum + current.length }, 0);
  }

  category = (playerPlace) => {
    if(playerPlace == 0)
      return 'Pop';
    if(playerPlace == 4)
      return 'Pop';
    if(playerPlace == 8)
      return 'Pop';
    if(playerPlace == 1)
      return 'Science';
    if(playerPlace == 5)
      return 'Science';
    if(playerPlace == 9)
      return 'Science';
    if(playerPlace == 2)
      return 'Sports';
    if(playerPlace == 6)
      return 'Sports';
    if(playerPlace == 10)
      return 'Sports';
    return 'Rock';
  }
}

const isOdd = (number) => {
  return number % 2 != 0;
}

exports.Game = function(props) {
  var players          = new Array();
  var places           = new Array(6);
  var purses           = new Array(6);
  var inPenaltyBox     = new Array(6);

  var questionBank     = new QuestionBank();

  var currentPlayer    = 0;
  var isGettingOutOfPenaltyBox = false;

  // "Settings"
  var amountToWin = 6;

  // TODO: constructor({ playerNames, amountToWin })
  if (props) {
    if (props.playerNames.length < 2 || props.playerNames.length > 6) {
      throw "Game should have 2 to 6 players.";
    }

    props.playerNames.map((playerName) => {
      players.push(playerName);
      places[players.length - 1] = 0;
      purses[players.length - 1] = 0;
      inPenaltyBox[players.length - 1] = false;

      console.log(playerName + " was added");
      console.log("They are player number " + players.length);
    });

    // Settings
    if (props.amountToWin) amountToWin = props.amountToWin;
  }

  // new getter methods, mainly for testing
  this.currentPlayerState = () => {
    return {
      player: new Player(places[currentPlayer], purses[currentPlayer], inPenaltyBox[currentPlayer], players[currentPlayer]),
      isGettingOutOfPenaltyBox
    }
  }
  this.questionBank = () => {
    return questionBank;
  }

  this.didPlayerWin = function(){
    return (purses[currentPlayer] == amountToWin)
  };

  this.isPlayable = function(howManyPlayers){
    return howManyPlayers >= 2;
  };

  this.getPlayers = () => {
    return players.map((_val, idx) => {
      return new Player(places[idx], purses[idx], inPenaltyBox[idx], players[idx])
    });
  };

  this.progressPlayer = () => {
    currentPlayer += 1;
    if(currentPlayer == players.length) currentPlayer = 0;
  };

  var askQuestion = function(){
    console.log(questionBank.shift({ playerPlace: places[currentPlayer] }));
  };

  this.roll = function(roll){
    console.log(players[currentPlayer] + " is the current player");
    console.log("They have rolled a " + roll);

    if(inPenaltyBox[currentPlayer] && !isOdd(roll)) {
      console.log(players[currentPlayer] + " is not getting out of the penalty box");
      return false;
    }

    if(inPenaltyBox[currentPlayer] && isOdd(roll)){
      console.log(players[currentPlayer] + " is out of the penalty box");
      inPenaltyBox[currentPlayer] = false;
    }

    places[currentPlayer] = places[currentPlayer] + roll;
    if(places[currentPlayer] > 11){
      places[currentPlayer] = places[currentPlayer] - 12;
    }

    console.log(players[currentPlayer] + "'s new location is " + places[currentPlayer]);
    console.log("The category is " + this.questionBank().category(places[currentPlayer]));
    askQuestion();

    return true;
  };

  this.wasCorrectlyAnswered = function(){
    // should not happen
    if(inPenaltyBox[currentPlayer]) return true;

    console.log("Answer was correct!!!!");

    purses[currentPlayer] += 1;
    console.log(players[currentPlayer] + " now has " +
                purses[currentPlayer]  + " Gold Coins.");
  };

  this.wrongAnswer = function(){
		console.log('Question was incorrectly answered');
		console.log(players[currentPlayer] + " was sent to the penalty box");
		inPenaltyBox[currentPlayer] = true;
  };
};

var game = new Game({ playerNames: ['Chet', 'Pat', 'Sue'] });

// TODO: the split of logic is a bit better now, but it's quite easy for wrong orders of actions to be done.
do {
  const canAnswerQuestion = game.roll(Math.floor(Math.random()*6) + 1); // 1 to 6
  if (canAnswerQuestion) {
    if (Math.floor(Math.random()*10) == 7){
      game.wrongAnswer();
    } else {
      game.wasCorrectlyAnswered();
    }
  }
  if (game.didPlayerWin()) break;

  game.progressPlayer();
} while(true); // is there a way to make this less risky?
