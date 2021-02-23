import 'package:serene/locator.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/reward_service.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/base_view_model.dart';

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
    var nav = locator<NavigationService>();
    switch (appStartupMode) {
      case AppStartupMode.normal:
        nav.navigateAndRemove(RouteNames.MAIN);
        break;
      case AppStartupMode.signin:
        nav.navigateAndRemove(RouteNames.LOG_IN);
        break;
      case AppStartupMode.preInternalisationAssessment:
        nav.navigateAndRemove(RouteNames.INTERNALISATION);
        break;
      case AppStartupMode.firstLaunch:
        nav.navigateAndRemove(RouteNames.INIT_VIDEO);
        // nav.navigateAndRemove(RouteNames.CONSENT);
        break;
      case AppStartupMode.postLearningAssessment:
        nav.navigateAndRemove(RouteNames.AMBULATORY_ASSESSMENT_POST_TEST);
        break;
      case AppStartupMode.internalisationTask:
        await nav.navigateAndRemove(
            RouteNames.AMBULATORY_ASSESSMENT_PRE_II_INTERNALISATION);
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

  addDebugText(String text) {
    this.debugTexts.add(text);
    notifyListeners();
  }

  Future<AppStartupMode> initialize() async {
    await locator<SettingsService>().initialize();
    addDebugText("Initialized Settings Service");
    bool userInitialized = await locator<UserService>().initialize();
    addDebugText("User Initialized: $userInitialized");
    if (!userInitialized) {
      return AppStartupMode.firstLaunch;
    }

    await locator<NotificationService>().initialize();
    addDebugText("Initialized Notification Service");
    addDebugText("Initialized Experiment Service");

    addDebugText("Current User: ${locator<UserService>().getUserEmail()}");
    addDebugText(
        "Waiting for the current start route from the experiment service");

    var experimentService = locator<ExperimentService>();
    await experimentService.initialize();
    locator<RewardService>().initialize();

    addDebugText("Time For Internalisation Task?");
    if (await experimentService.isTimeForInternalisationTask()) {
      return AppStartupMode.internalisationTask;
    }
    addDebugText("Time For Recall Task?");
    if (await experimentService.isTimeForRecallTask()) {
      return AppStartupMode.recallTask;
    }
    addDebugText("Time For Lexical Decision Task?");
    if (await experimentService.isTimeForLexicalDecisionTask()) {
      return AppStartupMode.lexicalDecisionTask;
    }
    addDebugText("Time For Usability Task?");
    if (await experimentService.isTimeForUsabilityTask()) {}

    addDebugText("No Tasks!");
    return AppStartupMode.noTasks;
  }
}
