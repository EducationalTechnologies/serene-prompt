import 'dart:async';

import 'package:serene/models/unlockable_background.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/logging_service.dart';

class RewardService {
  StreamController<int> controller;
  Stream<int> scoreStream;
  int scoreValue = 0;
  int gems = 0;
  int daysActive = 0;
  String backgroundImagePath = "assets/illustrations/mascot_bare.png";
  final DataService _dataService;
  final LoggingService _logService;

  List<UnlockableBackground> backgrounds = [
    UnlockableBackground("Standard", "assets/illustrations/mascot_bare.png", 0),
    UnlockableBackground(
        "Weltraum", "assets/illustrations/mascot_space.png", 5),
    UnlockableBackground("Ozean", "assets/illustrations/mascot_ocean.png", 10),
    UnlockableBackground("Lüfte", "assets/illustrations/mascot_plane.png", 15),
    UnlockableBackground(
        "Pyramiden", "assets/illustrations/mascot_pyramid.png", 20),
  ];

  RewardService(this._dataService, this._logService) {
    controller = StreamController.broadcast();
  }

  Future retrieveScore() async {
    _dataService.getScore().then((s) {
      scoreValue = s;
      controller.add(s);
      return s;
    });
  }

  Future getDaysActive() async {
    _dataService.getDaysActive().then((s) {
      daysActive = s;
      return s;
    });
  }

  Future getBackgroundImagePath() async {
    _dataService.getBackgroundImagePath().then((path) {
      if (path != null) {
        this.backgroundImagePath = path;
      }
      return backgroundImagePath;
    });
  }

  Future initialize() async {
    retrieveScore();
    getDaysActive();
    getBackgroundImagePath();
  }

  setBackgroundImagePath(String imagePath) async {
    this.backgroundImagePath = imagePath;
    _logService.logEvent("backgroundImageChanged", data: imagePath);
    await this._dataService.setBackgroundImage(imagePath);
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

  onLdtInitialLongLdtFinished() async {
    await addPoints(4);
  }

  onRecallTaskEverythingCompleted() async {}

  addDaysActive(int days) async {
    daysActive += days;
    await _dataService.saveDaysActive(daysActive);
  }

  addPoints(int points) async {
    scoreValue += points;
    controller.add(scoreValue);
    await _dataService.saveScore(scoreValue);
  }
}
