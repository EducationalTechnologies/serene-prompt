import 'dart:math';
import 'package:serene/models/user_data.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;

  String userId = "";

  SharedPreferences _prefs;

  Future<bool> initialize() {
    return SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      return true;
    }).catchError((error) {
      return false;
    });
  }

  Future<bool> isNameAvailable(String userId) async {
    return await FirebaseService().isNameAvailable(userId);
  }

  saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving username $username');
    await prefs.setString("userId", username);
  }

  saveUserEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving email $email');
    await prefs.setString("email", email);
  }

  Future<UserData> registerUser(String email, String password) async {
    var userData = await FirebaseService().registerUser(email, password);
    await saveUsername(userData.userId);
    await saveUserEmail(userData.email);
    return userData;
  }

  Future<UserData> signInUser(String email, String password) async {
    var userData = await FirebaseService().signInUser(email, password);
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
    return _prefs.getString("userId");
  }

  String getUserEmail() {
    return _prefs.getString("email");
  }

  UserService._internal() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
  }
}
