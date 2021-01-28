class LdtData {
  List<String> words = [];
  List<String> nonWords = [];
  List<String> targets = [];
  List<String> primes = [];
  int durationFixationCross = 1000;
  int durationPrime = 50;
  int durationBackwardMask = 700;
  int durationInterTrialScreen = 2000;
  List<LdtTrial> trials = [];
}

class LdtTrial {
  String target;
  String condition;
  int responseTime;
  int touchTime;
  int status;

  LdtTrial(
      {this.target,
      this.condition,
      this.responseTime = -1,
      this.touchTime = -1,
      this.status = -1});
}
