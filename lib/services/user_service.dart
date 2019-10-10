import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;

  String userId = "";

  SharedPreferences prefs;

  fetchData() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");
  }

  saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving username $username');
    await prefs.setString("userId", username);
  }

  getUsername() {
    return prefs.getString("userId");
  }

  UserService._internal() {
    fetchData();
  }
}
