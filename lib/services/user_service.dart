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

  saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving username $username');
    await prefs.setString("userId", username);
  }

  String getUsername() {
    if (_prefs != null) {
      return _prefs.getString("userId");
    }
    return "UserPrefs Not Instantiated!";
  }

  UserService._internal() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
  }
}
