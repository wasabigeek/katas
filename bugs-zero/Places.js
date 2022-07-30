class Places {
  static total = 12;

  // encapsulate mapping of place to question category
  static questionCategory = ({ playerPlace }) => {
    if ([0, 4, 8].includes(playerPlace))
      return 'Pop';
    if ([1, 5, 9].includes(playerPlace))
      return 'Science';
    if ([2, 6, 10].includes(playerPlace))
      return 'Sports';

    return 'Rock';
  };
  // encapsulate how many places there are here
  static indexFromRoll = ({ roll, playerPlace }) => {
    var newPlace = playerPlace + roll;
    if (newPlace > this.total - 1) {
      newPlace = newPlace - this.total;
    }

    return newPlace;
  };
}
exports.Places = Places;
