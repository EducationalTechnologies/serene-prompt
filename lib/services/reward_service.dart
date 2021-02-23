import 'package:serene/services/data_service.dart';

class RewardService {
  int score = 0;
  int gems = 0;

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

  onRecallTaskRegular() async {
    await addPoints(4);
  }

  onRecallTaskThird() async {
    await addPoints(8);
  }

  onFinalTask() async {
    await addPoints(10);
  }

  onRecallTaskEverythingCompleted() async {}

  addPoints(int points) async {
    score += points;
    await _dataService.saveScore(score);
  }
}
