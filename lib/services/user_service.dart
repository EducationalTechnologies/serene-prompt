import 'dart:math';
import 'package:serene/locator.dart';
import 'package:serene/models/user_data.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/shared/enums.dart';

class UserService {
  UserService(this._settings);

  SettingsService _settings;
  String userId = "";

  UserData _userData;

  Future<bool> initialize() {
    return Future.delayed(Duration.zero).then((res) => true);
  }

  Future<bool> isNameAvailable(String userId) async {
    return await FirebaseService().isNameAvailable(userId);
  }

  saveUsername(String username) async {
    await _settings.setSetting(SettingsKeys.userId, username);
  }

  saveUserEmail(String email) async {
    await _settings.setSetting(SettingsKeys.email, email);
  }

  int _getTreatmentGroup() {
    var rng = new Random();
    // TODO: This hardcoded value needs to go and the number of groups has to be stored somewhere else, maybe in an Experiment.json
    return rng.nextInt(1);
  }

  int _getInternalisationCondition() {
    var rng = new Random();
    // TODO: This hardcoded value needs to go and the number of groups has to be stored somewhere else, maybe in an Experiment.json
    return rng.nextInt(3);
  }

  Future<String> registerUser(String email, String password) async {
    var treatmentGroup = _getTreatmentGroup();
    var internalisationCondition = _getInternalisationCondition();
    var userData =
        await FirebaseService().registerUser(email, password, treatmentGroup);
    if (userData != null) {
      await saveUsername(userData.userId);
      await saveUserEmail(userData.email);
      this._userData = userData;
      return RegistrationCodes.SUCCESS;
    } else {
      return locator.get<FirebaseService>().lastError;
    }
  }

  Future<String> signInUser(String email, String password) async {
    var userData = await FirebaseService().signInUser(email, password);
    if (userData != null) {
      await saveUsername(userData.userId);
      await saveUserEmail(userData.email);
      this._userData = userData;
      return RegistrationCodes.SUCCESS;
    } else {
      return locator.get<FirebaseService>().lastError;
    }
  }

  saveRandomUser() async {
    var uid = _getRandomUsername();
    return await registerUser("$uid@edutec.guru", "123456");
  }

  _getRandomUsername() {
    var chars = "abcdefghijklmnopqrstuvwxyz0123456789!";
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < 16; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  String getUsername() {
    return _settings.getSetting(SettingsKeys.userId);
  }

  String getUserEmail() {
    return _settings.getSetting(SettingsKeys.email);
  }

  UserData getUserData() {
    return this._userData;
  }
}
