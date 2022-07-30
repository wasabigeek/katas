exports = typeof window !== "undefined" && window !== null ? window : global;

class Player {
  constructor(place, purse, inPenaltyBox, name) {
    this.place = place;
    this.purse = purse;
    this.inPenaltyBox = inPenaltyBox;
    this.name = name;
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

  var popQuestions     = new Array();
  var scienceQuestions = new Array();
  var sportsQuestions  = new Array();
  var rockQuestions    = new Array();

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
    return {
      totalRemaining: [popQuestions, scienceQuestions, sportsQuestions, rockQuestions].reduce((accum, current) => { return accum + current.length }, 0)
    }
  }

  this.didPlayerWin = function(){
    return (purses[currentPlayer] == amountToWin)
  };

  var currentCategory = function(){
    if(places[currentPlayer] == 0)
      return 'Pop';
    if(places[currentPlayer] == 4)
      return 'Pop';
    if(places[currentPlayer] == 8)
      return 'Pop';
    if(places[currentPlayer] == 1)
      return 'Science';
    if(places[currentPlayer] == 5)
      return 'Science';
    if(places[currentPlayer] == 9)
      return 'Science';
    if(places[currentPlayer] == 2)
      return 'Sports';
    if(places[currentPlayer] == 6)
      return 'Sports';
    if(places[currentPlayer] == 10)
      return 'Sports';
    return 'Rock';
  };

  this.createRockQuestion = function(index){
    return "Rock Question "+index;
  };

  for(var i = 0; i < 50; i++){
    popQuestions.push("Pop Question "+i);
    scienceQuestions.push("Science Question "+i);
    sportsQuestions.push("Sports Question "+i);
    rockQuestions.push(this.createRockQuestion(i));
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
    if(currentCategory() == 'Pop')
      console.log(popQuestions.shift());
    if(currentCategory() == 'Science')
      console.log(scienceQuestions.shift());
    if(currentCategory() == 'Sports')
      console.log(sportsQuestions.shift());
    if(currentCategory() == 'Rock')
      console.log(rockQuestions.shift());
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
    console.log("The category is " + currentCategory());
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
