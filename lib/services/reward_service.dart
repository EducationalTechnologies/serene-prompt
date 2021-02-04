import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';

class RewardService {
  int score = 0;

  final DataService _dataService;
  final ExperimentService _experimentService;

  Future<bool> initialized;

  RewardService(this._dataService, this._experimentService);

  Future initialize() async {
    _dataService.getScore().then((s) {
      this.score = s;
      initialized = Future.value(true);
    });
  }

  void getScore() {
    initialized = null;
    _dataService.getScore().then((score) {
      score = score;
      // initialized = true;
      initialized = Future.value(true);
    });
  }

  addPoints(int points) async {
    score += points;
    await _dataService.saveScore(score);
  }
}
