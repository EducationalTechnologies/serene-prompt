import 'package:flutter/widgets.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/shared/enums.dart';

class TimerViewModel with ChangeNotifier {
  SettingsService _settingsService;

  Duration _duration;

  Duration get duration => _duration;

  setDuration(Duration duration) async {
    _duration = duration;
    await this._settingsService.setSetting(
        SettingsKeys.timerDurationInSeconds, duration.inSeconds.toString());
  }

  TimerViewModel(this._settingsService) {
    
    this._duration = Duration(seconds: int.parse(_settingsService.getSetting(SettingsKeys)))
  }
}
