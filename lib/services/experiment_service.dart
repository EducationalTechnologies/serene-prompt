import 'package:serene/services/data_service.dart';
import 'package:serene/shared/enums.dart';

class ExperimentService {
  DataService _dataService;

  ExperimentService(this._dataService);

  Future<bool> initialize() {
    return Future.delayed(Duration.zero).then((res) => true);
  }

  // TODO: Request whether a pre-learning assessment was performed today
  Future<bool> shouldShowPreLearningAssessment() async {
    var lastPreLearningAssessment = await this
        ._dataService
        .getLastSubmittedAssessment(AssessmentType.preLearning);

    return false;
    if (lastPreLearningAssessment == null) return true;
    return !isToday(lastPreLearningAssessment.submissionDate);
  }

  // TODO: Request whether a post-learning assessment was performed yesterday
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

  isToday(DateTime dateTime) {
    var today = DateTime.now();
    return dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day;
  }
}
