import 'package:serene/models/unlockable_background.dart';
import 'package:serene/services/data_service.dart';

class RewardService {
  int score = 0;
  int gems = 0;
  int daysActive = 0;
  String backgroundImagePath = "assets/illustrations/mascot_bare.png";
  final DataService _dataService;

  List<UnlockableBackground> backgrounds = [
    UnlockableBackground("Standard", "assets/illustrations/mascot_bare.png", 0),
    UnlockableBackground(
        "Weltraum", "assets/illustrations/mascot_space.png", 5),
    UnlockableBackground("Ozean", "assets/illustrations/mascot_ocean.png", 10),
    UnlockableBackground("Lüfte", "assets/illustrations/mascot_plane.png", 15),
    UnlockableBackground(
        "Pyramiden", "assets/illustrations/mascot_pyramid.png", 20),
  ];

  Future<bool> initialized;

  RewardService(this._dataService);

  Future initialize() async {
    _dataService.getScore().then((s) {
      this.score = s;
      initialized = Future.value(true);
    });

    _dataService.getBackgroundImagePath().then((path) {
      if (path != null) {
        this.backgroundImagePath = path;
      }
      initialized = Future.value(true);
    });
  }

  setBackgroundImagePath(String imagePath) async {
    this.backgroundImagePath = imagePath;
    await this._dataService.setBackgroundImage(imagePath);
  }

  void getScore() {
    initialized = null;
    _dataService.getScore().then((score) {
      score = score;
      // initialized = true;
      initialized = Future.value(true);
    });
  }

  onRecallTask(int streakDays) async {
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
