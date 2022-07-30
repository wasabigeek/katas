class Places {
  static total = 12;

  // encapsulate mapping of place to question category
  static questionCategory = ({ playerPlace }) => {
    switch (playerPlace % 4) {
      case 0:
        return 'Pop';
      case 1:
        return 'Science';
      case 2:
        return 'Sports';
      default:
        return 'Rock';
    }
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
