import 'package:flutter/material.dart';
import 'package:implementation_intentions/shared/app_colors.dart';
import 'package:implementation_intentions/shared/router.dart';
import 'package:implementation_intentions/state/app_state.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      builder: (_) => AppState(),
      child: MaterialApp(
        title: 'Serene',
        theme: ThemeData(
            canvasColor: AppColors.backgroundColor,
            primarySwatch: Colors.teal,
            accentColor: Color(0xfff96d15),
            buttonColor: Colors.orange[300],
            iconTheme: IconThemeData(color: Colors.black)),
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
