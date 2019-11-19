import 'package:serene/services/data_service.dart';

class ExperimentService {
  DataService _dataService;

  ExperimentService(this._dataService);

  Future<bool> initialize() {
    return Future.delayed(Duration.zero).then((res) => true);
  }

  Future<bool> shouldShowPreLearningAssessment() {
    return Future.delayed(Duration.zero).then((res) => true);
  }
}
