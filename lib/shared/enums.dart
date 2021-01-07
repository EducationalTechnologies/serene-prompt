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
  static const String dailyQuestion = "dailyQuestion";
  static const String postTest = "postTest";
  static const String preLearning = "preLearning";
  static const String postLearning = "postLearning";
  static const String srl = "srlSurvey";
  static const String preImplementationIntention = "preImplementationIntention";
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

class Hindrances {
  static const String OVERWHELMED = "Überforderung";
  static const String DISTRACTED = "Ablenkung";
  static const String LISTLESSNESS = "Lustlosigkeit";
  static const String PHYSICAL_CONDITION = "Körperliche Verfassung";
}

class RegistrationCodes {
  static const SUCCESS = "SUCCESS";
  static const WEAK_PASSWORD = "ERROR_WEAK_PASSWORD";
  static const INVALID_CREDENTIAL = "ERROR_INVALID_CREDENTIAL";
  static const EMAIL_ALREADY_IN_USE = "ERROR_EMAIL_ALREADY_IN_USE";
}

class ExperimentalGroup {
  static const Control = "Control";
  static const ExperimentGoalShieldingPersonalized =
      "Experiment_GoalShielding_Personalized";
}

enum InternalisationCondition { waiting, scrambleWithHint, scrambleWithoutHint }

enum AppStartupMode {
  normal,
  signin,
  preLearningAssessment,
  firstLaunch,
  postLearningAssessment,
  noTasks,
  internalisationTask,
  recallTask
}
