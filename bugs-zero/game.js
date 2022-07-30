exports = typeof window !== "undefined" && window !== null ? window : global;

class Player {
  constructor(place, purse, inPenaltyBox, name) {
    this.place = place;
    this.purse = purse;
    this.inPenaltyBox = inPenaltyBox;
    this.name = name;
  }
}

class Places {
  static total = 12;

  // encapsulate mapping of place to question category
  static questionCategory = ({ playerPlace }) => {
    if([0, 4, 8].includes(playerPlace))
      return 'Pop';
    if([1, 5, 9].includes(playerPlace))
      return 'Science';
    if([2, 6, 10].includes(playerPlace))
      return 'Sports';

    return 'Rock';
  }
  // encapsulate how many places there are here
  static indexFromRoll = ({ roll, playerPlace }) => {
    var newPlace = playerPlace + roll;
    if(newPlace > this.total - 1){
      newPlace = newPlace - this.total;
    }

    return newPlace;
  }
}

// This doesn't have as much reason to exist outside of Game anymore 🤔.
// Note that this only works now because the questions can be built from the category and index.
// If we had an actual bank of questions then I think this and Places would be coupled w.r.t. the categories.
class QuestionBank {
  constructor() {
    this.questionIndexes = {}
  }

  shift = ({ category }) => {
    if (!this.questionIndexes[category]) this.questionIndexes[category] = 0;

    const currentQuestion = `${category} Question ${this.questionIndexes[category]}`;
    this.questionIndexes[category] += 1;
    return currentQuestion;
  }

  askedCount = () => {
    return Object
      .keys(this.questionIndexes)
      .reduce((accum, current) => { return accum + this.questionIndexes[current] }, 0);
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
    const questionText = questionBank.shift({ category: Places.questionCategory(places[currentPlayer]) });
    console.log(questionText);
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

    places[currentPlayer] = Places.indexFromRoll({ roll, playerPlace: places[currentPlayer] })
    console.log(players[currentPlayer] + "'s new location is " + places[currentPlayer]);
    console.log("The category is " + Places.questionCategory(places[currentPlayer]));
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
