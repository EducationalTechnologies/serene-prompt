import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;


  fetchData() async {
    // // fetchGoals();
    // // fetchGoalShields();
    // // getOpenGoals();
    // return _goalShields;
  }

  saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('Saving username $username');
    await prefs.setString("username", username);
  }

  UserService._internal() {
    fetchData();
  }
}
