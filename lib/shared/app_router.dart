import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/locator.dart';
import 'package:serene/screens/assessment/evening_assessment_screen.dart';
import 'package:serene/screens/assessment/morning_assessment_screen.dart';
import 'package:serene/screens/initialsession/initial_session_screen.dart';
import 'package:serene/screens/internalisation/internalisation_recall_screen.dart';
import 'package:serene/screens/internalisation/internalisation_screen.dart';
import 'package:serene/screens/login_screen.dart';
import 'package:serene/screens/no_task_screen.dart';
import 'package:serene/screens/questionnaire/lexical_decision_task_screen.dart';
import 'package:serene/screens/settings_screen.dart';
import 'package:serene/screens/test_screen.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/ambulatory_assessment_view_model.dart';
import 'package:serene/viewmodels/consent_view_model.dart';
import 'package:serene/screens/assessment/ambulatory_assessment_screen.dart';
import 'package:serene/screens/consent_screen.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/screen_args.dart';
import 'package:serene/viewmodels/evening_assessment_view_model.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';
import 'package:serene/viewmodels/internalisation_recall_view_model.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';
import 'package:serene/viewmodels/lexical_decision_task_view_model.dart';
import 'package:serene/viewmodels/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:serene/viewmodels/morning_assessment_view_model.dart';
import 'package:serene/viewmodels/settings_view_model.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
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
                ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                    create: (_) => AmbulatoryAssessmentViewModel(
                        AssessmentTypes.usability,
                        locator.get<DataService>(),
                        locator.get<ExperimentService>()),
                    child: AmbulatoryAssessmentScreen()));

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

      case RouteNames.INIT_START:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<InitSessionViewModel>(
                  create: (_) => InitSessionViewModel(
                      locator.get<DataService>(),
                      locator.get<ExperimentService>(),
                      locator.get<SettingsService>()),
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
