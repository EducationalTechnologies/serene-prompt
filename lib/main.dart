import 'package:flutter/material.dart';
import 'package:serene/locator.dart';
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
  buildMaterialApp() {
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
      initialRoute: RouteNames.MAIN,
      // routes: Router.getRoutes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildMaterialApp();
  }
}
