import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/viewmodels/startup_view_model.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: I NEED THIS FOR DEBUGGING ATM! REMOVE LATER
    var vm = Provider.of<StartupViewModel>(context);
    return Container(
      color: Colors.white,
      child: Text(vm.debugText),
    );

    return Container(
      color: Colors.white,
      child: Image.asset("assets/icons/icon_512.png"),
    );
  }
}
