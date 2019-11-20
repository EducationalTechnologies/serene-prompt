import 'package:serene/services/data_service.dart';

class ExperimentService {
  DataService _dataService;

  ExperimentService(this._dataService);

  Future<bool> initialize() {
    return Future.delayed(Duration.zero).then((res) => true);
  }

  // TODO: Request whether a pre-learning assessment was performed today
  Future<bool> shouldShowPreLearningAssessment() {
    return Future.delayed(Duration.zero).then((res) => false);
  }

  // TODO: Request whether a post-learning assessment was performed yesterday
  Future<bool> shouldShowPostLearningAssessment() {
    return Future.delayed(Duration.zero).then((res) => true);
  }

    // TODO: Request whether a post-learning assessment was performed yesterday
  Future<bool> shouldShowSRLSurvey() {
    return Future.delayed(Duration.zero).then((res) => true);
  }
}
