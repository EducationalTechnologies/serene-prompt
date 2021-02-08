import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/startup_view_model.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: I NEED THIS FOR DEBUGGING ATM! REMOVE LATER
    var vm = Provider.of<StartupViewModel>(context);
    return Container(
        color: Colors.white,
        child: ListView(
          children: [
            RaisedButton(
                child: Text("Zum Log Screen"),
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteNames.TEST);
                }),
            for (var t in vm.debugTexts)
              Text(t, style: TextStyle(fontSize: 14)),
          ],
        ));

    return Container(
      color: Colors.white,
      child: Image.asset("assets/icons/icon_512.png"),
    );
  }
}
