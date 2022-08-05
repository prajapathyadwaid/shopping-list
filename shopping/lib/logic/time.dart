String getGreeting() {
  var greeting = ["Morning", "Afternoon", "Evening"];
  var time = DateTime.now().hour;
  if (time >= 3 && time < 12) {
    return greeting[0];
  } else if (time >= 12 && time <= 17) {
    return greeting[1];
  } else {
    return greeting[2];
  }
}
