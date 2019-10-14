import 'package:get_it/get_it.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/user_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<UserService>(UserService());
  locator.registerSingleton<DataService>(DataService());
  locator.registerSingleton<FirebaseService>(FirebaseService());
  locator.registerSingleton<NotificationService>(NotificationService());
}
