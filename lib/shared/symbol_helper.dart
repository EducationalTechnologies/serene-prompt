import 'package:serene/shared/enums.dart';

class SymbolHelper {
  static getSymbolForDifficulty(String difficulty) {
    if (difficulty == GoalDifficulty.easy) {
      return "❖";
    }
    if (difficulty == GoalDifficulty.medium) {
      return "❖❖";
    }
    if (difficulty == GoalDifficulty.hard) {
      return "❖❖❖";
    }
    if (difficulty == GoalDifficulty.trivial) {
      return ":)";
    }
  }
}