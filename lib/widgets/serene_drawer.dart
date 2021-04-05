import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/locator.dart';
import 'package:serene/screens/assessment/ambulatory_assessment_screen.dart';
import 'package:serene/screens/internalisation/internalisation_screen.dart';
import 'package:serene/services/data_service.dart';
import 'package:serene/services/experiment_service.dart';
import 'package:serene/services/user_service.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/ambulatory_assessment_view_model.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';
import 'package:serene/widgets/version_info.dart';

class SereneDrawer extends StatelessWidget {
  SereneDrawer();

  _buildDrawerItem(
      {IconData icon = Icons.ac_unit,
      String text = "",
      GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  buildLDTSelection(BuildContext context) {
    List trials = ["0_1", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

    return AlertDialog(content: Text("Trial auswählen"), actions: [
      for (var t in trials)
        TextButton(
          child: Text(
            t,
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, RouteNames.LDT, arguments: t);
          },
        )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            title: Container(
              padding: EdgeInsets.only(top: 20, bottom: 10.0),
              child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/icons/icon_256.png'),
                          fit: BoxFit.cover)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(locator<UserService>().getUsername()),
                        VersionInfo()
                      ])),
            ),
          ),
          Divider(),
          // _buildDrawerItem(
          //     icon: Icons.add_box,
          //     text: "Neues Ziel",
          //     onTap: () async {
          //       await Navigator.pushNamed(context, RouteNames.ADD_GOAL);
          //       Navigator.pop(context);
          //       await Navigator.pushNamed(context, RouteNames.MAIN);
          //     }),
          _buildDrawerItem(
              icon: Icons.filter_1,
              text: "Einloggen",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteNames.LOG_IN);
              }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.filter_2,
              text: "Fragen",
              onTap: () {
                Navigator.pop(context);

                var routeWidget =
                    ChangeNotifierProvider<AmbulatoryAssessmentViewModel>(
                        create: (_) => AmbulatoryAssessmentViewModel(
                            AssessmentTypes.dailyQuestionsAll,
                            locator.get<DataService>(),
                            locator.get<ExperimentService>()),
                        child: AmbulatoryAssessmentScreen());

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => routeWidget));
              }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.filter_3,
              text: "Internalisierung Warten",
              onTap: () {
                var route = ChangeNotifierProvider<InternalisationViewModel>(
                    create: (_) => InternalisationViewModel.forUsability(
                        InternalisationCondition.waiting,
                        locator.get<DataService>(),
                        locator.get<ExperimentService>()),
                    child: InternalisationScreen());
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => route));
              }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.filter_4,
              text: "Internalisierung Emoji",
              onTap: () {
                var route = ChangeNotifierProvider<InternalisationViewModel>(
                    create: (_) => InternalisationViewModel.forUsability(
                        InternalisationCondition.emoji,
                        locator.get<DataService>(),
                        locator.get<ExperimentService>()),
                    child: InternalisationScreen());
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => route));
              }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.filter_5,
              text: "Internalisierung Puzzle",
              onTap: () {
                var route = ChangeNotifierProvider<InternalisationViewModel>(
                    create: (_) => InternalisationViewModel.forUsability(
                        InternalisationCondition.scrambleWithHint,
                        locator.get<DataService>(),
                        locator.get<ExperimentService>()),
                    child: InternalisationScreen());
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => route));
              }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.wb_sunny,
              text: "Morgenfragen",
              onTap: () {
                Navigator.pushNamed(
                    context, RouteNames.AMBULATORY_ASSESSMENT_MORNING,
                    arguments: "1");
              }),
          // VersionInfo()
          Divider(),
          _buildDrawerItem(
              icon: Icons.nightlight_round,
              text: "Abendfragen",
              onTap: () {
                Navigator.pushNamed(
                    context, RouteNames.AMBULATORY_ASSESSMENT_EVENING,
                    arguments: "1");
              }),
        ],
      ),
    );
  }
}
