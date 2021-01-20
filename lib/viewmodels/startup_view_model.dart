import 'package:serene/locator.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/base_view_model.dart';

class StartupViewModel extends BaseViewModel {
  String debugText = "Wurst";

  StartupViewModel() {
    print("Startup");
    Future.delayed(Duration.zero).then((v) async {
      var appStartupMode = await initialize();
      startApp(appStartupMode);
    });
  }

  /*
   * Navigate with replacement to prevent back navigation to the splash screen
   */
  void startApp(AppStartupMode appStartupMode) {
    var nav = locator<NavigationService>();
    switch (appStartupMode) {
      case AppStartupMode.normal:
        nav.navigateAndRemove(RouteNames.MAIN);
        break;
      case AppStartupMode.signin:
        nav.navigateAndRemove(RouteNames.LOG_IN);
        break;
      case AppStartupMode.preLearningAssessment:
        nav.navigateAndRemove(RouteNames.INTERNALISATION);
        break;
      case AppStartupMode.firstLaunch:
        // nav.navigateAndRemove(RouteNames.LOG_IN);
        nav.navigateAndRemove(RouteNames.CONSENT);
        break;
      case AppStartupMode.postLearningAssessment:
        nav.navigateAndRemove(RouteNames.AMBULATORY_ASSESSMENT_POST_TEST);
        break;
      case AppStartupMode.internalisationTask:
        nav.navigateAndRemove(RouteNames.INTERNALISATION);
        break;
      case AppStartupMode.recallTask:
        nav.navigateAndRemove(RouteNames.RECALL_TASK);
        break;
      case AppStartupMode.noTasks:
        nav.navigateAndRemove(RouteNames.NO_TASKS);
        break;
      case AppStartupMode.lexicalDecisionTask:
        nav.navigateAndRemove(RouteNames.LDT);
    }
  }

  setDebugText(String text) {
    this.debugText = text;
    notifyListeners();
  }

  Future<AppStartupMode> initialize() async {
    await locator<SettingsService>().initialize();
    setDebugText("Initialized Settings Service");
    await locator<UserService>().initialize();
    setDebugText("Initialized User Service");
    await locator<NotificationService>().initialize();
    setDebugText("Initialized Notification Service");
    var experimentService = locator<ExperimentService>();
    await experimentService.initialize();
    setDebugText("Initialized Experiment Service");
    bool userInitialized =
        locator<UserService>().getUsername()?.isNotEmpty ?? false;
    setDebugText("Initialized Experiment Service");
    if (!userInitialized) {
      return AppStartupMode.firstLaunch;
    }

    return await experimentService.getCurrentStartRoute();
  }
}
