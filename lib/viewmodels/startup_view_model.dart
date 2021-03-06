import 'package:prompt/locator.dart';
import 'package:prompt/services/data_service.dart';
import 'package:prompt/services/experiment_service.dart';
import 'package:prompt/services/navigation_service.dart';
import 'package:prompt/services/notification_service.dart';
import 'package:prompt/services/reward_service.dart';
import 'package:prompt/services/settings_service.dart';
import 'package:prompt/services/user_service.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/route_names.dart';
import 'package:prompt/viewmodels/base_view_model.dart';

class StartupViewModel extends BaseViewModel {
  List<String> debugTexts = [];

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
  Future<void> startApp(AppStartupMode appStartupMode) async {
    print("Navigating to ${appStartupMode.toString()}");
    var nav = locator<NavigationService>();
    // return nav.navigateAndRemove(RouteNames.NO_TASKS);
    switch (appStartupMode) {
      case AppStartupMode.normal:
        nav.navigateAndRemove(RouteNames.MAIN);
        break;
      case AppStartupMode.signin:
        nav.navigateAndRemove(RouteNames.LOG_IN);
        break;
      case AppStartupMode.firstLaunch:
        nav.navigateAndRemove(RouteNames.LOG_IN);
        break;
      case AppStartupMode.internalisationTask:
        await nav.navigateAndRemove(RouteNames.NO_TASKS);
        break;
      case AppStartupMode.recallTask:
        nav.navigateAndRemove(RouteNames.NO_TASKS);
        break;
      case AppStartupMode.noTasks:
        nav.navigateAndRemove(RouteNames.NO_TASKS);
        break;
      case AppStartupMode.lexicalDecisionTask:
        nav.navigateAndRemove(RouteNames.NO_TASKS);
        break;
    }
  }

  addDebugText(String text) {
    this.debugTexts.add(text);
    notifyListeners();
  }

  Future<AppStartupMode> initialize() async {
    await locator<SettingsService>().initialize();
    addDebugText("Initialized Settings Service");
    await locator<NotificationService>().initialize();
    addDebugText("Initialized Notification Service");
    var experimentService = locator<ExperimentService>();
    await experimentService.initialize();
    await locator<RewardService>().initialize();

    bool userInitialized = await locator<UserService>().initialize();
    addDebugText("User Initialized: $userInitialized");
    bool signedIn = locator<UserService>().isSignedIn();
    if (!userInitialized || !signedIn) {
      return AppStartupMode.firstLaunch;
    }

    var userData = await locator<DataService>().getUserData();
    if (userData == null) {
      return AppStartupMode.firstLaunch;
    }

    // addDebugText("Time For Internalisation Task?");
    // if (await experimentService.isTimeForInternalisationTask()) {
    //   return AppStartupMode.internalisationTask;
    // }
    // addDebugText("Time For Recall Task?");
    // if (await experimentService.isTimeForRecallTask()) {
    //   return AppStartupMode.recallTask;
    // }
    // addDebugText("Time For Lexical Decision Task?");
    // if (await experimentService.isTimeForLexicalDecisionTask()) {
    //   return AppStartupMode.lexicalDecisionTask;
    // }

    // addDebugText("No Tasks!");
    return AppStartupMode.noTasks;
  }
}
