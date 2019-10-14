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

  _buildAssessmentListForGoal() {
    return Column(
      children: <Widget>[
        IntervalScale(
            title:
                "Wie verpflichtet fühlt du dich, diese Ziel heute zu erreichen?"),
        UIHelper.verticalSpaceMedium(),
        IntervalScale(
            title: "Wie schwierig wird es heute, dieses Ziel zu erreichen?"),
        UIHelper.verticalSpaceMedium(),
        IntervalScale(title: "Wie sehr freust du dich auf diese Aufgabe?")
      ],
    );
  }

  _buildAssessmentListAfterGoal() {
    return Column(
      children: <Widget>[
        IntervalScale(
          title: "Warst du heute während des Lernens überfordert?",
          itemCount: 2,
          labels: {1: "Ja", 2: "Nein"},
        ),
        UIHelper.verticalSpaceMedium(),
        IntervalScale(
          title:
              "Hast du es dann geschafft, dir zu sagen, dass du es trotzdem schaffen kannst?",
          itemCount: 2,
          labels: {1: "Ja", 2: "Nein"},
        ),
        UIHelper.verticalSpaceMedium(),
        IntervalScale(
          title: "Wie zufrieden bist du mit dem heutigen Lerntag?",
          itemCount: 5,
        )
      ],
    );
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
              "Wie habe während des Lernens immer wieder bewusst an meinen Plan gedacht.",
          itemCount: 5,
          labels: labels,
        ),
        UIHelper.verticalSpaceMedium(),
        IntervalScale(
          title:
              "Der Plan hat mir geholfen, meine Lernziele besser zu erreichen.",
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AmbulatoryAssessmentState>(
      builder: (_) => AmbulatoryAssessmentState(),
      child: Scaffold(
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
              child: _buildAssessmentListPostTest(context)),
        ),
      ),
    );
  }
}
