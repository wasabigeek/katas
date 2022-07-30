const { Places } = require("../Places");

describe("questionCategory", function() {
  it("returns Pop on the right indexes", function() {
    expect(Places.questionCategory({ playerPlace: 0 })).toEqual("Pop");
    expect(Places.questionCategory({ playerPlace: 4 })).toEqual("Pop");
    expect(Places.questionCategory({ playerPlace: 8 })).toEqual("Pop");
  });
  it("returns Science on the right indexes", function() {
    expect(Places.questionCategory({ playerPlace: 1 })).toEqual("Science");
    expect(Places.questionCategory({ playerPlace: 5 })).toEqual("Science");
    expect(Places.questionCategory({ playerPlace: 9 })).toEqual("Science");
  });
  it("returns Sports on the right indexes", function() {
    expect(Places.questionCategory({ playerPlace: 2 })).toEqual("Sports");
    expect(Places.questionCategory({ playerPlace: 6 })).toEqual("Sports");
    expect(Places.questionCategory({ playerPlace: 10 })).toEqual("Sports");
  });
  it("returns Rock on the right indexes", function() {
    expect(Places.questionCategory({ playerPlace: 3 })).toEqual("Rock");
    expect(Places.questionCategory({ playerPlace: 7 })).toEqual("Rock");
    expect(Places.questionCategory({ playerPlace: 11 })).toEqual("Rock");
  });
});
