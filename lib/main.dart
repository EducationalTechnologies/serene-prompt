import 'package:flutter/material.dart';
import 'package:serene/locator.dart';
import 'package:serene/screens/splash_screen.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/services/notification_service.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<AppStartupMode> initialize() async {
    await locator.get<SettingsService>().initialize();
    await locator.get<UserService>().initialize();
    await locator.get<NotificationService>().initialize();
    bool userInitialized =
        locator.get<UserService>().getUsername()?.isNotEmpty ?? false;
    if (!userInitialized) {
      return AppStartupMode.firstLaunch;
    }

    var experimentService = locator.get<ExperimentService>();
    await experimentService.initialize();

    if (await experimentService.shouldShowPreLearningAssessment()) {
      return AppStartupMode.preLearningAssessment;
    }

    if (await experimentService.shouldShowPostLearningAssessment()) {
      return AppStartupMode.postLearningAssessment;
    }
    return AppStartupMode.normal;
  }

  buildWaitingIndicator() {
    // return Center(child: CircularProgressIndicator());
    return SplashScreen();
  }

  buildMaterialApp(String initialRoute) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // debugShowMaterialGrid: true,
      title: 'Serene',
      theme: ThemeData(
          canvasColor: Colors.white,
          primarySwatch: Colors.orange,
          accentColor: Color(0xfff96d15),
          buttonColor: Colors.orange[300],
          selectedRowColor: Colors.orange[200],
          buttonTheme: ButtonThemeData(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          iconTheme: IconThemeData(color: Colors.black)),
      onGenerateRoute: Router.generateRoute,
      navigatorKey: locator.get<NotificationService>().navigatorKey,
      // home: MainScreen(),
      initialRoute: initialRoute,
      // routes: Router.getRoutes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (false) {
      return buildMaterialApp(RouteNames.MAIN);
    } else {
      return FutureBuilder<AppStartupMode>(
          future: initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return buildWaitingIndicator();
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  switch (snapshot.data) {
                    case AppStartupMode.normal:
                      return buildMaterialApp(RouteNames.MAIN);
                      break;
                    case AppStartupMode.signin:
                      return buildMaterialApp(RouteNames.LOG_IN);
                      break;
                    case AppStartupMode.preLearningAssessment:
                      return buildMaterialApp(RouteNames.GOAL_SHIELDING);
                      break;
                    case AppStartupMode.firstLaunch:
                      return buildMaterialApp(RouteNames.LOG_IN);
                      break;
                    case AppStartupMode.postLearningAssessment:
                      return buildMaterialApp(
                          RouteNames.AMBULATORY_ASSESSMENT_POST_TEST);
                      break;
                  }
                }
                return buildWaitingIndicator();
                break;
              default:
                return buildWaitingIndicator();
            }
          });
    }
  }
}

//   enum InitializationState{
//     loading,
//     noUser,
//     ready
//   }

// class InitializerWidget extends StatefulWidget {
//   @override
//   _InitializerWidgetState createState() => _InitializerWidgetState();
// }

// class _InitializerWidgetState extends State<InitializerWidget> {

//   InitializationState _initializationState = InitializationState.loading;

//   @override
//   void initState() {

//   }

//   Future<bool> _initialize() async {
//     await locator.get<SettingsService>().initialize();
//     await locator.get<UserService>().initialize();
//     await locator.get<NotificationService>().initialize();
//     bool userInitialized =
//         locator.get<UserService>().getUsername()?.isNotEmpty ?? false;
//     return userInitialized;
//   }

//   _buildWaitingIndicator() {
//     return Center(child: CircularProgressIndicator());
//   }

//   _buildMaterialApp(String initialRoute) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // debugShowMaterialGrid: true,
//       title: 'Serene',
//       theme: ThemeData(
//           canvasColor: Colors.white,
//           primarySwatch: Colors.orange,
//           accentColor: Color(0xfff96d15),
//           buttonColor: Colors.orange[300],
//           selectedRowColor: Colors.orange[200],
//           buttonTheme: ButtonThemeData(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           ),
//           iconTheme: IconThemeData(color: Colors.black)),
//       onGenerateRoute: Router.generateRoute,
//       navigatorKey: locator.get<NotificationService>().navigatorKey,
//       // home: MainScreen(),
//       initialRoute: initialRoute,
//       // routes: Router.getRoutes(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     switch(_initializationState) {

//       case InitializationState.loading:
//         return _buildWaitingIndicator();
//         break;
//       case InitializationState.noUser:
//         _buildMaterialApp(RouteNames.MAIN);
//         break;
//       case InitializationState.ready:
//         _buildMaterialApp(RouteNames.MAIN);
//         break;
//     }
//   }
// }
