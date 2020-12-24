import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/screens/internalisation/long_press_internalisation.dart';
import 'package:serene/screens/internalisation/scramble_internalisation.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';
import 'package:serene/widgets/serene_appbar.dart';
import 'package:serene/widgets/serene_drawer.dart';

class InternalisationScreen extends StatefulWidget {
  InternalisationScreen({Key key}) : super(key: key);

  @override
  _InternalisationScreenState createState() => _InternalisationScreenState();
}

class _InternalisationScreenState extends State<InternalisationScreen> {
  getInternalisationScrenForCondition(int condition) {
    switch (condition) {
      case 0:
        return LongPressInternalisation();
      case 1:
        return ScrambleInternalisation(true);
      case 2:
        return ScrambleInternalisation(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<InternalisationViewModel>(context);
    var child =
        getInternalisationScrenForCondition(vm.internalisationCondition);

    return Scaffold(
      appBar: SereneAppBar(),
      drawer: SereneDrawer(),
      body: Container(
        child: child,
      ),
    );
  }
}
