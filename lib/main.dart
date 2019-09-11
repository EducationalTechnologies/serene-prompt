import 'package:flutter/material.dart';
import 'package:implementation_intentions/shared/router.dart';
import 'package:implementation_intentions/state/app_state.dart';
import 'package:provider/provider.dart';

// Currently following https://medium.com/flutter-community/flutter-architecture-provider-implementation-guide-d33133a9a4e8

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      builder: (_) => AppState(),
      child: MaterialApp(
        title: 'Serene',
        theme: ThemeData(

          // textTheme: TextTheme(
          //     body1: TextStyle(fontSize: 16.0, color: Colors.black),
          //     body2: TextStyle(fontSize: 14.0, color: Colors.blue)),
          primarySwatch: Colors.amber,
        ),
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
