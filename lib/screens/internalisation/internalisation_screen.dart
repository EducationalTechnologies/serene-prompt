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
  getScreenForCondition(InternalisationCondition condition) {
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: SereneAppBar(),
        drawer: SereneDrawer(),
        body: FutureBuilder(
          future: vm.init(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Container(
                // child: getScreenForCondition(vm.internalisationCondition),
                child: ScrambleInternalisation(true),
              );
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
