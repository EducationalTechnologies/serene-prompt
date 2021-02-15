import 'package:serene/services/data_service.dart';

class RewardService {
  int score = 0;

  final DataService _dataService;

  Future<bool> initialized;

  RewardService(this._dataService);

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
