import 'dart:math';
import 'package:serene/models/user_data.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/shared/enums.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  UserService(this._settings);

  SettingsService _settings;
  String userId = "";

  Future<bool> initialize() {
    return Future.delayed(Duration.zero).then((res) => true);
  }

  Future<bool> isNameAvailable(String userId) async {
    return await FirebaseService().isNameAvailable(userId);
  }

  saveUsername(String username) async {
    await _settings.setSetting("userId", username);
  }

  saveUserEmail(String email) async {
    await _settings.setSetting("email", email);
  }

  Future<UserData> registerUser(String email, String password) async {
    var userData = await FirebaseService().registerUser(email, password);
    await saveUsername(userData.userId);
    await saveUserEmail(userData.email);
    return userData;
  }

  Future<UserData> signInUser(String email, String password) async {
    var userData = await FirebaseService().signInUser(email, password);
    await saveUsername(userData.userId);
    await saveUserEmail(userData.email);
    return userData;
  }

  saveRandomUser() async {
    var uid = _getRandomUsername();
    await saveUsername("$uid@edutec.guru");
    await saveUserEmail("$uid@edutec.guru");
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

  UserService._internal() {
    // SharedPreferences.getInstance().then((prefs) {
    //   _prefs = prefs;
    // });
  }
}
