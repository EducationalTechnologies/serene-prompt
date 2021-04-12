import 'package:prompt/services/settings_service.dart';
import 'package:prompt/viewmodels/base_view_model.dart';

class SettingsViewModel extends BaseViewModel {
  SettingsService _settingsService;

  double _wordsPerMinute;

  get wordsPerMinute => _wordsPerMinute;

  SettingsViewModel(this._settingsService) {
    this._wordsPerMinute = _settingsService.getWordsPerMinute();
  }

  setWordsPerMinute(double newValue) async {
    this._wordsPerMinute = newValue;
    notifyListeners();
  }

  submit() async {
    await this._settingsService.setWordsPerMinute(_wordsPerMinute);
  }
}
