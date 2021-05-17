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
  static const String initSessionStep = "initSessionStep";
  static const String backGroundImage = "backgroundImage";
  static const String backgroundColors = "backgroundColors";
  static const String hasSeenEmojiCondition = "hasSeenEmojiCondition";
  static const String hasSeenWaitingCondition = "hasSeenWaitingCondition";
  static const String hasSeenPuzzleCondition = "hasSeenPuzzleCondition";
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
  static const USER_NOT_FOUND = "user-not-found";
}

class ExperimentalGroup {
  static const Control = "Control";
  static const ExperimentGoalShieldingPersonalized =
      "Experiment_GoalShielding_Personalized";
}

enum HelpType {
  general,
  emojiInternalisation,
  waitingInternalisation,
  scrambleInternalisation,
  recall
}

enum InternalisationCondition {
  waiting,
  scrambleWithHint,
  emoji,
}

enum AppStartupMode {
  normal,
  signin,
  firstLaunch,
  noTasks,
  internalisationTask,
  recallTask,
  lexicalDecisionTask,
}

enum AssessmentTypes {
  affect,
  dailyLearningIntention,
  dailyObstacle,
  didLearnToday,
  evening,
  itLiteracy,
  postTest,
  preLearning,
  postLearning,
  usability,
  cabuuLearn,
  regulation,
  selfEfficacy,
  goals,
  srl,
  learningGoals1,
  learningGoals2,
  success,
  visibilitySelection,
  visibilityCouldRead,
  finalAttitude,
  finalMotivation
}

enum NoTaskSituation {
  standard,
  afterInitialization,
  afterRecall,
  afterLdt,
  afterFinal,
  afterInternalisation
}

enum DailyLearningIntention { yes, no, unsure, alreadyDid }
