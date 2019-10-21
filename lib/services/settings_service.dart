import 'package:serene/services/local_database_service.dart';
import 'package:serene/shared/enums.dart';

class SettingsService {
  // SharedPreferences _prefs;
  LocalDatabaseService _databaseService;

  Map<String, dynamic> _settingsCache = {
    SettingsKeys.userId: "",
    SettingsKeys.email: "",
    SettingsKeys.timerDurationInSeconds: 1500
  };

  SettingsService(this._databaseService) {}

  Future<bool> initialize() async {
    // return SharedPreferences.getInstance().then((prefs) {
    //   _prefs = prefs;
    //   return true;
    // }).catchError((error) {
    //   return false;
    // });
    var settings = await _databaseService.getAllSettings();
    for (var setting in settings) {
      print("Setting from db is $setting");
      _settingsCache[setting["key"]] = setting["value"];
    }
    return true;
  }

  // SettingsService._internal() {
  //   SharedPreferences.getInstance().then((prefs) {
  //     _prefs = prefs;
  //   });
  // }

  getSetting(String setting) {
    return _settingsCache[setting];
    // return await this._databaseService.getSettingsValue(setting);
  }

  setSetting(String setting, String value) async {
    await this
        ._databaseService
        .upsertSetting(setting, value); //_prefs.setString(setting, value);
    _settingsCache[setting] = value;
  }

  // static final SettingsService _instance = SettingsService._internal();
  // factory SettingsService() => _instance;
}
