import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/state/ambulatory_assessment_state.dart';
import 'package:serene/widgets/interval_scale.dart';
import 'package:provider/provider.dart';

class AmbulatoryAssessmentScreen extends StatelessWidget {
  _buildAssessmentList() {
    return Column(
      children: <Widget>[
        _buildAssessment("Wie geht es dir heute?", "mood"),
        IntervalScale(title: "Wie geht es dir heute?")
      ],
    );
  }

  _buildAssessment(String title, String groupValue) {
    return Column(children: <Widget>[
      Text(title),
      Row(
        children: <Widget>[
          Radio(
            groupValue: groupValue,
            value: "1",
            onChanged: (val) {
              print("Radio Button change to " + val);
            },
          ),
          Radio(
            groupValue: groupValue,
            value: "2",
            onChanged: (val) {
              print("Radio Button change to " + val);
            },
          ),
          Radio(
            groupValue: groupValue,
            value: "3",
            onChanged: (val) {
              print("Radio Button change to " + val);
            },
          ),
          Radio(
            groupValue: groupValue,
            value: "4",
            onChanged: (val) {
              print("Radio Button change to " + val);
            },
          )
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AmbulatoryAssessmentState>(
      builder: (_) => AmbulatoryAssessmentState(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Neues Ziel'),
          actions: <Widget>[
            FlatButton.icon(
                textColor: Colors.white,
                icon: const Icon(Icons.save),
                label: Text("Speichern"),
                onPressed: () async {
                  final appState =
                      Provider.of<AmbulatoryAssessmentState>(context);
                  Navigator.pop(context);
                }),
          ],
        ),
        body: Container(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildAssessmentList()),
        ),
      ),
    );
  }
}
