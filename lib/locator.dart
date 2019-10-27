import 'package:get_it/get_it.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/local_database_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/services/user_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<LocalDatabaseService>(LocalDatabaseService.db);
  locator.registerSingleton<FirebaseService>(FirebaseService());
  locator.registerSingleton<SettingsService>(
      SettingsService(locator.get<LocalDatabaseService>()));
  locator.registerSingleton<UserService>(
      UserService(locator.get<SettingsService>()));
  locator.registerSingleton<DataService>(DataService());
  locator.registerSingleton<NotificationService>(NotificationService());
}
