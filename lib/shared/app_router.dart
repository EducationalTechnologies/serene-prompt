import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prompt/locator.dart';
import 'package:prompt/screens/assessment/evening_assessment_screen.dart';
import 'package:prompt/screens/assessment/finish_assessment_screen.dart';
import 'package:prompt/screens/assessment/morning_assessment_screen.dart';
import 'package:prompt/screens/assessment/usability_assessment_screen.dart';
import 'package:prompt/screens/initialsession/initial_session_screen.dart';
import 'package:prompt/screens/internalisation/internalisation_recall_screen.dart';
import 'package:prompt/screens/internalisation/internalisation_screen.dart';
import 'package:prompt/screens/login_screen.dart';
import 'package:prompt/screens/no_task_screen.dart';
import 'package:prompt/screens/questionnaire/lexical_decision_task_screen.dart';
import 'package:prompt/screens/settings_screen.dart';
import 'package:prompt/screens/test_screen.dart';
import 'package:prompt/services/data_service.dart';
import 'package:prompt/services/experiment_service.dart';
import 'package:prompt/services/logging_service.dart';
import 'package:prompt/services/navigation_service.dart';
import 'package:prompt/services/reward_service.dart';
import 'package:prompt/services/settings_service.dart';
import 'package:prompt/services/user_service.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/viewmodels/ambulatory_assessment_view_model.dart';
import 'package:prompt/viewmodels/consent_view_model.dart';
import 'package:prompt/screens/assessment/ambulatory_assessment_screen.dart';
import 'package:prompt/screens/consent_screen.dart';
import 'package:prompt/shared/route_names.dart';
import 'package:prompt/shared/screen_args.dart';
import 'package:prompt/viewmodels/evening_assessment_view_model.dart';
import 'package:prompt/viewmodels/finish_assessment_view_model.dart';
import 'package:prompt/viewmodels/init_session_view_model.dart';
import 'package:prompt/viewmodels/internalisation_recall_view_model.dart';
import 'package:prompt/viewmodels/internalisation_view_model.dart';
import 'package:prompt/viewmodels/lexical_decision_task_view_model.dart';
import 'package:prompt/viewmodels/login_view_model.dart';
import 'package:prompt/viewmodels/usability_assessment_view_model.dart';
import 'package:provider/provider.dart';
import 'package:prompt/viewmodels/morning_assessment_view_model.dart';
import 'package:prompt/viewmodels/settings_view_model.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    locator<LoggingService>().logEvent("navigation",
        data: {"routeName": settings.name, "routeArgs": settings.arguments});
    switch (settings.name) {
      case RouteNames.INTERNALISATION:
        return MaterialPageRoute(
            builder: (context) =>
                ChangeNotifierProvider<InternalisationViewModel>(
                    create: (_) => InternalisationViewModel(
                        locator.get<DataService>(),
                        locator.get<ExperimentService>()),
                    child: InternalisationScreen()));

      case RouteNames.RECALL_TASK:
        return MaterialPageRoute(
            builder: (context) =>
                ChangeNotifierProvider<InternalisationRecallViewModel>(
                    create: (_) => InternalisationRecallViewModel(
                        locator.get<ExperimentService>()),
                    child: InternalisationRecallScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT:
        final AssessmentScreenArguments assessmentArgs = settings.arguments;
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        assessmentArgs.assessmentType,
                        locator.get<DataService>(),
                        locator.get<ExperimentService>()),
                    child: AmbulatoryAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_USABILITY:
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<UsabilityAssessmentViewModel>(
                    create: (_) => UsabilityAssessmentViewModel(
                        locator.get<DataService>(),
                        locator.get<ExperimentService>()),
                    child: UsabilityAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_PRE_TEST:
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        AssessmentTypes.preLearning,
                        locator.get<DataService>(),
                        locator.get<ExperimentService>()),
                    child: AmbulatoryAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_MORNING:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<MorningAssessmentViewModel>(
                create: (_) => MorningAssessmentViewModel(
                    locator.get<DataService>(),
                    locator.get<ExperimentService>()),
                child: MorningAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_EVENING:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<EveningAssessmentViewModel>(
                create: (_) => EveningAssessmentViewModel(
                    locator.get<DataService>(),
                    locator.get<ExperimentService>()),
                child: EveningAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_FINISH:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<FinishAssessmentViewModel>(
                create: (_) => FinishAssessmentViewModel(
                    locator.get<DataService>(),
                    locator.get<ExperimentService>()),
                child: FinishAssessmentScreen()));

      case RouteNames.AMBULATORY_ASSESSMENT_PRE_II_INTERNALISATION:
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        AssessmentTypes.affect,
                        locator.get<DataService>(),
                        locator.get<ExperimentService>()),
                    child: AmbulatoryAssessmentScreen()));

      case RouteNames.CONSENT:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<ConsentViewModel>(
                create: (_) => ConsentViewModel(
                    locator.get<DataService>(),
                    locator.get<UserService>(),
                    locator.get<NavigationService>()),
                child: ConsentScreen()));

      case RouteNames.LOG_IN:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<LoginViewModel>(
                create: (_) => LoginViewModel(locator.get<UserService>(),
                    locator.get<NavigationService>()),
                child: LoginScreen(
                  backgroundColor1: Colors.orange[50],
                  backgroundColor2: Colors.orange[50],
                  highlightColor: Colors.blue,
                  foregroundColor: Colors.blue[300],
                )));

      case RouteNames.SETTINGS:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<SettingsViewModel>(
                create: (_) =>
                    SettingsViewModel(locator.get<SettingsService>()),
                child: SettingsScreen()));

      case RouteNames.TEST:
        return MaterialPageRoute(builder: (_) => TestScreen());

      case RouteNames.NO_TASKS:
        return MaterialPageRoute(builder: (_) => NoTasksScreen());

      case RouteNames.NO_TASKS_AFTER_RECALL:
        return MaterialPageRoute(
            builder: (_) => NoTasksScreen(
                  previousRoute: NoTaskSituation.afterRecall,
                ));

      case RouteNames.NO_TASKS_AFTER_LDT:
        return MaterialPageRoute(
            builder: (_) => NoTasksScreen(
                  previousRoute: NoTaskSituation.afterLdt,
                ));

      case RouteNames.NO_TASKS_AFTER_INITIALIZATION:
        return MaterialPageRoute(
            builder: (_) => NoTasksScreen(
                  previousRoute: NoTaskSituation.afterInitialization,
                ));

      case RouteNames.INIT_START:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<InitSessionViewModel>(
                  create: (_) => InitSessionViewModel(
                      locator.get<DataService>(),
                      locator.get<ExperimentService>(),
                      locator.get<RewardService>()),
                  child: InitialSessionScreen(),
                ));

      case RouteNames.LDT:
        final String trialName = settings.arguments;
        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<LexicalDecisionTaskViewModel>(
                  create: (_) => LexicalDecisionTaskViewModel(
                      trialName, locator.get<ExperimentService>()),
                  child: LexicalDecisionTaskScren(),
                ));

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
              body: Center(
            child: Text('No route defined for ${settings.name}'),
          ));
        });
    }
  }
}
