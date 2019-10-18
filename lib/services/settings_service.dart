import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SharedPreferences _prefs;

  Future<bool> initialize() {
    return SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      return true;
    }).catchError((error) {
      return false;
    });
  }

  SettingsService._internal() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
  }

  getSetting(String setting) {
    return _prefs.getString("email");
  }

  setSetting(String setting, String value) async {
    return await _prefs.setString(setting, value);
  }

  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
}
