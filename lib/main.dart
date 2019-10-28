import 'package:flutter/material.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/router.dart';

// TOOD: Wrap whole app in futurbuilder to perform initialization logic
// https://stackoverflow.com/questions/50437687/flutter-initialising-variables-on-startup
void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> initialize() async {
    await locator.get<SettingsService>().initialize();
    await locator.get<UserService>().initialize();
    bool userInitialized =
        locator.get<UserService>().getUsername()?.isNotEmpty ?? false;
    return userInitialized;
  }

  buildWaitingIndicator() {
    return Center(child: CircularProgressIndicator());
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
              default:
                return buildWaitingIndicator();
            }
          });
    }
  }
}
