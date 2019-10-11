import 'package:flutter/material.dart';
import 'package:serene/screens/main_screen.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/router.dart';
import 'package:serene/shared/app_colors.dart';
import 'package:serene/state/app_state.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

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
    return ChangeNotifierProvider<AppState>(
      builder: (_) => AppState(),
      child: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.topLeft,
              end: new Alignment(
                  1.0, 0.0), // 10% of the width, so there are ten blinds.
              colors: [Colors.orange[50], Colors.orange[50]], // whitish to gray
              // tileMode: TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
          child: buildMaterialApp()),
    );
  }
}
