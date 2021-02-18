import 'package:get_it/get_it.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/services/firebase_service.dart';
import 'package:serene/services/local_database_service.dart';
import 'package:serene/services/logging_service.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/reward_service.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/services/user_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<NavigationService>(NavigationService());

  locator.registerSingleton<LocalDatabaseService>(LocalDatabaseService.db);

  locator.registerSingleton<FirebaseService>(FirebaseService());

  locator.registerSingleton<SettingsService>(
      SettingsService(locator.get<LocalDatabaseService>()));

  locator.registerSingleton<UserService>(
      UserService(locator.get<SettingsService>()));

  locator.registerSingleton<DataService>(
      DataService(locator.get<FirebaseService>(), locator.get<UserService>()));

  locator.registerSingleton<LoggingService>(
      LoggingService(locator.get<DataService>()));

  locator.registerSingleton<NotificationService>(NotificationService());

  locator.registerSingleton<RewardService>(
      RewardService(locator.get<DataService>()));

  locator.registerSingleton<ExperimentService>(ExperimentService(
      locator.get<DataService>(),
      locator.get<NotificationService>(),
      locator.get<LoggingService>(),
      locator.get<RewardService>(),
      locator.get<NavigationService>()));
}
