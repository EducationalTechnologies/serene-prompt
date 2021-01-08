import 'package:flutter/material.dart';
import 'package:serene/locator.dart';
import 'package:serene/screens/startup_screen.dart';
import 'package:serene/services/navigation_service.dart';
import 'package:serene/shared/app_router.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  buildMaterialApp() {
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
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          iconTheme: IconThemeData(color: Colors.black)),
      onGenerateRoute: AppRouter.generateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
      home: StartupScreen(),
      // initialRoute: initialRoute,
      // routes: Router.getRoutes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildMaterialApp();
  }
}
