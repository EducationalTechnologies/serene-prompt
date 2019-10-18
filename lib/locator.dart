import 'package:get_it/get_it.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/services/user_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<SettingsService>(SettingsService());
  locator.registerSingleton<UserService>(UserService());
  locator.registerSingleton<FirebaseService>(FirebaseService());
  locator.registerSingleton<DataService>(DataService());
  locator.registerSingleton<NotificationService>(NotificationService());
}
