import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prompt/models/unlockable_background.dart';
import 'package:prompt/services/data_service.dart';
import 'package:prompt/services/logging_service.dart';

class RewardService {
  StreamController<int> controller;
  Stream<int> scoreStream;
  int scoreValue = 0;
  int gems = 0;
  int daysActive = 0;
  int streakDays = 0;
  String backgroundImagePath = "assets/illustrations/mascot_bare.png";
  // LinearGradient _baseGradient =
  LinearGradient backgroundColor = LinearGradient(
    colors: [Colors.orange[50], Colors.orange[50]],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  final DataService _dataService;
  final LoggingService _logService;

  List<UnlockableBackground> backgrounds = [
    UnlockableBackground("Monster", "assets/illustrations/mascot_bare.png", 0,
        backgroundColor:
            LinearGradient(colors: [Colors.orange[50], Colors.orange[50]])),
    UnlockableBackground(
        "Flugzeug", "assets/illustrations/mascot_plane_2.png", 0,
        backgroundColor:
            LinearGradient(colors: [Colors.orange[50], Color(0xff9fc7f0)])),
    UnlockableBackground("Ozean", "assets/illustrations/mascot_space_2.png", 1,
        backgroundColor:
            LinearGradient(colors: [Colors.orange[50], Color(0xff9fc7f0)])),
    UnlockableBackground(
        "Pyramiden", "assets/illustrations/mascot_pyramid.png", 3,
        backgroundColor:
            LinearGradient(colors: [Colors.orange[50], Color(0xffa2d0ff)])),
    UnlockableBackground(
        "Vulkan 1", "assets/illustrations/mascot_vulcan_1.png", 6,
        backgroundColor:
            LinearGradient(colors: [Colors.orange[50], Color(0xffa2d0ff)])),
    UnlockableBackground(
        "Wikinger", "assets/illustrations/mascot_viking_1.png", 9,
        backgroundColor:
            LinearGradient(colors: [Colors.orange[50], Color(0xffa2d0ff)])),
    UnlockableBackground(
        "Ozean 1", "assets/illustrations/mascot_ocean_2.png", 12,
        backgroundColor:
            LinearGradient(colors: [Colors.orange[50], Color(0xffa2d0ff)])),
    UnlockableBackground(
        "Pyramide 2", "assets/illustrations/mascot_pyramid_2.png", 15,
        backgroundColor:
            LinearGradient(colors: [Colors.orange[50], Color(0xffa2d0ff)])),
    UnlockableBackground(
        "Weltraum", "assets/illustrations/mascot_space_2.png", 18,
        backgroundColor:
            LinearGradient(colors: [Colors.orange[50], Color(0xff9fc7f0)])),
    UnlockableBackground(
        "Zauberei 2", "assets/illustrations/mascot_vulcan_2.png", 21,
        backgroundColor:
            LinearGradient(colors: [Colors.orange[50], Color(0xff9fc7f0)])),
    UnlockableBackground(
        "Wikinger 2", "assets/illustrations/mascot_viking_2.png", 24,
        backgroundColor:
            LinearGradient(colors: [Colors.orange[50], Color(0xffa2d0ff)])),
    UnlockableBackground(
        "Wikinger 2", "assets/illustrations/mascot_wizard_2.png", 27,
        backgroundColor:
            LinearGradient(colors: [Colors.orange[50], Color(0xffa2d0ff)])),
  ];

  RewardService(this._dataService, this._logService) {
    controller = StreamController.broadcast();
  }

  Future retrieveScore() async {
    await _dataService.getScore().then((s) {
      scoreValue = s;
      controller.add(s);
      return s;
    });
  }

  Future getDaysActive() async {
    await _dataService.getDaysActive().then((s) {
      daysActive = s;
      return s;
    });
  }

  Future<int> getStreakDays() async {
    return await _dataService.getStreakDays().then((s) {
      streakDays = s;
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

  Future<List<Color>> getBackgroundColors() async {
    _dataService.getBackgroundGradientColors().then((colors) {
      if (colors != null) {
        var backgroundColor = LinearGradient(
          colors: colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
        setBackgroundColor(backgroundColor);
      }
      return colors;
    });
    return backgroundColor.colors;
  }

  Future initialize() async {
    await retrieveScore();
    await getDaysActive();
    await getStreakDays();
    await getBackgroundImagePath();
  }

  setBackgroundImagePath(String imagePath) async {
    this.backgroundImagePath = imagePath;
    _logService.logEvent("backgroundImageChanged", data: {"path": imagePath});
    await this._dataService.setBackgroundImage(imagePath);
  }

  setBackgroundColor(LinearGradient lg) async {
    this.backgroundColor = LinearGradient(
      colors: lg.colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    await this._dataService.saveBackgroundGradientColors(lg.colors);
  }

  onRecallTask() async {
    int points = 10 + daysActive;
    await addPoints(points);
  }

  onFinalTask() async {
    await addPoints(10);
  }

  onLdtInitialLongLdtFinished() async {
    await addPoints(5);
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

  addStreakDays(int days) async {
    streakDays += days;
    await _dataService.setStreakDays(days);
  }
}
