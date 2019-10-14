import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/state/ambulatory_assessment_state.dart';
import 'package:serene/widgets/interval_scale.dart';
import 'package:provider/provider.dart';

class AmbulatoryAssessmentScreen extends StatelessWidget {
  _submit(BuildContext context) {
    var assessmentState = Provider.of<AmbulatoryAssessmentState>(context);
  }

  _buildAssessmentListPostTest(BuildContext context) {
    final labels = {
      1: "Nie",
      2: "Selten",
      3: "Gelegentlich",
      4: "Oft",
      5: "Sehr oft"
    };

    return Column(
      children: <Widget>[
        UIHelper.verticalSpaceMedium(),
        IntervalScale(
          title:
              "Ich habe mir Mühe gegeben, meinen Plan für den Tag zu verinnerlichen",
          itemCount: 5,
          labels: labels,
        ),
        UIHelper.verticalSpaceMedium(),
        IntervalScale(
          title: "Ich habe gedacht: 'So ein Plan bringt doch gar nichts!'",
          itemCount: 5,
          labels: labels,
        ),
        UIHelper.verticalSpaceMedium(),
        IntervalScale(
          title:
              "Ich habe während des Lernens immer wieder bewusst an meinen Plan gedacht",
          itemCount: 5,
          labels: labels,
        ),
        UIHelper.verticalSpaceMedium(),
        IntervalScale(
          title:
              "Der Plan hat mir geholfen, meine Lernziele besser zu erreichen",
          itemCount: 5,
          labels: labels,
        ),
        UIHelper.verticalSpaceMedium(),
        RaisedButton(
          onPressed: () {
            _submit(context);
          },
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          child: Text("Speichern", style: TextStyle(fontSize: 20)),
        )
      ],
    );
  }

  _buildAssessmentList(BuildContext context) {
    var assessment =
        Provider.of<AmbulatoryAssessmentState>(context).currentAssessment;
    // return ListView.builder(
    //   itemCount: assessment.length,
    //   itemBuilder: (context, index) {
    //     return Card(
    //         child: Padding(
    //       padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
    //       child: IntervalScale(
    //         title: assessment[index].title,
    //         itemCount: assessment[index].itemCount,
    //         labels: assessment[index].labels,
    //       ),
    //     ));
    //   },
    // );
    return ListView(
      children: <Widget>[
        for (var index = 0; index < assessment.length; index++)
          Card(
              child: Padding(
            padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
            child: IntervalScale(
              title: assessment[index].title,
              itemCount: assessment[index].itemCount,
              labels: assessment[index].labels,
            ),
          )),
        SizedBox(
            width: double.infinity,
            height: 60,
            child: RaisedButton(
              onPressed: () {
                _submit(context);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              child: Text("Speichern", style: TextStyle(fontSize: 20)),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fragen zur Zielsetzung'),
        actions: <Widget>[
          FlatButton.icon(
              textColor: Colors.white,
              icon: const Icon(Icons.save),
              label: Text("Speichern"),
              onPressed: () async {
                Navigator.pop(context);
              }),
        ],
      ),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildAssessmentList(context)),
      ),
    );
  }
}
