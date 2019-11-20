enum ViewState { idle, busy }

class GoalProgressIndicator {
  static const String checkbox = "checkbox";
  static const String slider = "slider";
}

class GoalDifficulty {
  static const String trivial = "trivial";
  static const String easy = "easy";
  static const String medium = "medium";
  static const String hard = "hard";
}

class GoalScreenMode {
  static const String create = "create";
  static const String edit = "edit";
}

class AssessmentType {
  static const String postTest = "postTest";
  static const String preLearning = "preLearning";
  static const String postLearning = "postLearning";
  static const String srl = "srlSurvey";
}

class ResourceType {
  static const String book = "book";
  static const String link = "link";
  static const String app = "app";
}

class SettingsKeys {
  static const String userId = "userId";
  static const String email = "email";
  static const String timerDurationInSeconds = "timerDurationInSeconds";
  static const String wordsPerMinute = "wordsPerMinute";
}

enum AppStartupMode {
  normal,
  signin,
  preLearningAssessment,
  firstLaunch,
  postLearningAssessment
}
