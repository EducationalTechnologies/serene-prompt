import 'dart:math';
import 'package:prompt/locator.dart';
import 'package:prompt/models/user_data.dart';
import 'package:prompt/services/firebase_service.dart';
import 'package:prompt/services/settings_service.dart';
import 'package:prompt/shared/enums.dart';

class UserService {
  UserService(this._settings);

  SettingsService _settings;
  String userId = "";

  Future<bool> initialize() async {
    var id = getUsername();
    if (id == null) return false;
    if (id.isEmpty) return false;
    return !await FirebaseService().isNameAvailable(id);
  }

  Future<bool> isNameAvailable(String userId) async {
    return await FirebaseService().isNameAvailable(userId);
  }

  saveUsername(String username) async {
    await _settings.setSetting(SettingsKeys.userId, username);
  }

  int _getInternalisationCondition() {
    var rng = new Random();
    // TODO: This hardcoded value needs to go and the number of groups has to be stored somewhere else, maybe in an Experiment.json
    return rng.nextInt(2) + 1;
  }

  Future<String> registerUser(String email, String password) async {
    var treatmentGroup = _getInternalisationCondition();
    var userData =
        await FirebaseService().registerUser(email, password, treatmentGroup);
    if (userData != null) {
      await saveUsername(email);
      return RegistrationCodes.SUCCESS;
    } else {
      return locator.get<FirebaseService>().lastError;
    }
  }

  static UserData getDefaultUserData(email, {uid = ""}) {
    var rng = Random();
    var condition = rng.nextInt(6);
    condition += 1;
    return UserData(
        userId: uid,
        email: email,
        group: condition,
        score: 0,
        streakDays: 0,
        registrationDate: DateTime.now());
  }

  Future<String> signInUser(String email, String password) async {
    var user = await FirebaseService().signInUser(email, password);
    if (user != null) {
      await saveUsername(email);
      var userData = await FirebaseService().getUserData(email);
      if (userData == null) {
        var defaultUserData = getDefaultUserData(email, uid: user.uid);
        await FirebaseService().insertUserData(defaultUserData);
      }
      return RegistrationCodes.SUCCESS;
    } else {
      return locator.get<FirebaseService>().lastError;
    }
  }

  saveRandomUser() async {
    var uid = _getRandomUsername();
    return await registerUser("$uid@edutec.science", "123456");
  }

  _getRandomUsername() {
    var chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < 12; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  String getUsername() {
    return _settings.getSetting(SettingsKeys.userId);
  }

  Future<bool> isSignedIn() async {
    return await FirebaseService().getCurrentUser().then((value) {
      if (value == null) return false;
      return true;
    });
  }
}
