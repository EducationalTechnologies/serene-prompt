import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/screens/internalisation/scramble_internalisation.dart';
import 'package:serene/screens/internalisation/waiting_internalisation_screen.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';
import 'package:serene/widgets/serene_appbar.dart';
import 'package:serene/widgets/serene_drawer.dart';

class InternalisationScreen extends StatefulWidget {
  InternalisationScreen({Key key}) : super(key: key);

  @override
  _InternalisationScreenState createState() => _InternalisationScreenState();
}

class _InternalisationScreenState extends State<InternalisationScreen> {
  getInternalisationScrenForCondition(InternalisationCondition condition) {
    switch (condition) {
      case InternalisationCondition.waiting:
        return WaitingInternalisationScreen();
        break;
      case InternalisationCondition.scrambleWithHint:
        return ScrambleInternalisation(true);
        break;
      case InternalisationCondition.scrambleWithoutHint:
        return ScrambleInternalisation(false);
        break;
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
