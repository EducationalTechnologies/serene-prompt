class LdtData {
  List<String> targets = [];
  List<String> primes = [];
  List<int> correctValues = [];
  int durationFixationCross = 1000;
  int durationPrime = 50;
  int durationBackwardMask = 700;
  int durationInterTrialScreen = 2000;
  DateTime startDate = DateTime.now();
  DateTime completionDate = DateTime.now();
  List<LdtTrial> trials = [];

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> trialMap = trials.map((e) => e.toMap()).toList();

    return {
      "targets": targets,
      "primes": primes,
      "durationFixationCross": durationFixationCross,
      "durationPrime": durationPrime,
      "durationBackwardMask": durationBackwardMask,
      "durationInterTrialScreen": durationInterTrialScreen,
      "startDate": startDate.toIso8601String(),
      "completionDate": completionDate.toIso8601String(),
      "trials": trialMap
    };
  }
}

class LdtTrial {
  String target;
  String condition;
  int responseTime;
  int selection;
  int primeDuration = 0;

  Map<String, dynamic> toMap() {
    return {
      "target": target,
      "condition": condition,
      "responseTime": responseTime,
      "selection": selection,
      "primeDuration": primeDuration
    };
  }

  LdtTrial(
      {this.target = "",
      this.condition = "",
      this.responseTime = -1,
      this.selection = -1});
}
