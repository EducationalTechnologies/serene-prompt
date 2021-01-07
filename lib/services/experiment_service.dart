import 'package:serene/services/data_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/extensions.dart';

class ExperimentService {
  DataService _dataService;

  ExperimentService(this._dataService);

  Future<bool> initialize() async {
    return await Future.delayed(Duration.zero).then((res) => true);
  }

  Future<bool> shouldShowPreLearningAssessment() async {
    var lastPreLearningAssessment = await this
        ._dataService
        .getLastSubmittedAssessment(AssessmentType.preLearning);

    // return false;
    if (lastPreLearningAssessment == null) return true;
    return !lastPreLearningAssessment.submissionDate.isToday();
  }

  Future<bool> shouldShowPostLearningAssessment() async {
    var lastPostLearningAssessment = await this
        ._dataService
        .getLastSubmittedAssessment(AssessmentType.postLearning);

    if (lastPostLearningAssessment == null) return true;
    var diff =
        DateTime.now().difference(lastPostLearningAssessment.submissionDate);

    // TOOD: Rethink this value
    return diff.inHours > 24;
  }

  // TODO: Request whether a post-learning assessment was performed yesterday
  Future<bool> shouldShowSRLSurvey() {
    return Future.delayed(Duration.zero).then((res) => true);
  }

  Future<bool> shouldShowDailyQuestion() {
    return Future.delayed(Duration.zero).then((res) => true);
  }

  Future<bool> isTimeForInternalisationTask() async {
    var lastInternalisation = await _dataService.getLastInternalisation();

    if (lastInternalisation == null) {
      return true;
    }

    if (lastInternalisation.completionDate.isToday()) {
      return false;
    }

    var now = DateTime.now();
    if (now.hour >= 18) {
      return false;
    }
    return true;
  }

  // TODO: Implement
  Future<bool> isTimeForRecallTask() async {
    return await Future.delayed(Duration.zero).then((value) {
      return false;
    });
  }

  // TODO: Implement
  Future<bool> isTimeForLexicalDecisionTask() async {
    return await Future.delayed(Duration.zero).then((value) {
      return false;
    });
  }

  // TODO: Implement
  Future<bool> isTimeForUsabilityTask() async {
    return await Future.delayed(Duration.zero).then((value) {
      return false;
    });
  }

  // TODO: Implement
  Future<bool> isRecallTaskDone() async {
    return await Future.delayed(Duration.zero).then((value) {
      return false;
    });
  }
}
