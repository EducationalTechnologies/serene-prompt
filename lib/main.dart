import 'package:flutter/material.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/router.dart';
import 'package:serene/shared/app_colors.dart';

// TOOD: Wrap whole app in futurbuilder to perform initialization logic
// https://stackoverflow.com/questions/50437687/flutter-initialising-variables-on-startup
void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> initialize() {
    // services
    bool initialized = false;
    return Future.delayed(Duration(seconds: 2)).then((val) async {
      await locator.get<UserService>().initialize();
      bool userInitialized =
          locator.get<UserService>().getUsername()?.isNotEmpty ?? false;
      return userInitialized;
    });
  }

  buildWaitingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  buildMaterialApp(String initialRoute) {
    return MaterialApp(
      title: 'Serene',
      theme: ThemeData(
          canvasColor: AppColors.backgroundColor,
          primarySwatch: Colors.orange,
          accentColor: Color(0xfff96d15),
          buttonColor: Colors.orange[300],
          buttonTheme: ButtonThemeData(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          iconTheme: IconThemeData(color: Colors.black)),
      onGenerateRoute: Router.generateRoute,
      // home: MainScreen(),
      initialRoute: initialRoute,
      // routes: Router.getRoutes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildMaterialApp(RouteNames.MAIN);
    return FutureBuilder<bool>(
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
                if (snapshot.data) {
                  return buildMaterialApp(RouteNames.MAIN);
                } else {
                  return buildMaterialApp(RouteNames.LOG_IN);
                }
              }
              return buildWaitingIndicator();
              break;
          }
        });
  }
}
