import 'package:flutter/material.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/widgets/interval_scale.dart';

typedef void ItemSelectedCallback(
    String assessment, String itemId, String value);

class Questionnaire extends StatefulWidget {
  final Assessment assessment;
  final ItemSelectedCallback onFinished;
  const Questionnaire(this.assessment, this.onFinished, {Key key})
      : super(key: key);

  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  Map<String, String> _results = {};

  @override
  Widget build(BuildContext context) {
    print(widget.assessment.title);
    if (widget.assessment == null)
      return Container(child: CircularProgressIndicator());
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Card(
              child: Container(
            padding: EdgeInsets.all(10),
            child: SizedBox(
                width: double.infinity,
                child: Text(
                  widget.assessment.title,
                  textAlign: TextAlign.center,
                  style: (TextStyle(fontSize: 18)),
                )),
          )),
          for (var index = 0; index < widget.assessment.items.length; index++)
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: IntervalScale(
                    title: widget.assessment.items[index].title,
                    labels: widget.assessment.items[index].labels,
                    id: widget.assessment.items[index].id,
                    // groupValue: vm.getResultForIndex(index),
                    callback: (val) {
                      print("Changed Assessment value to: $val");
                      setState(() {
                        this.widget.onFinished(widget.assessment.id,
                            widget.assessment.items[index].id, val);
                        _results[widget.assessment.items[index].id] = val;
                      });
                    },
                  ),
                )),
          UIHelper.verticalSpaceMedium(),
          Visibility(
            visible: !_isFilledOut(),
            child: Text(
                "Du hast noch nicht alle Fragen beantwortet. Sobald du für alle Fragen eine Auswahl getroffen hast, kannst du weiter zum nächsten Schritt"),
          )
        ],
      ),
    );
  }

  bool _isFilledOut() {
    bool canSubmit = true;
    for (var assessmentItem in widget.assessment.items) {
      if (!_results.containsKey(assessmentItem.id)) canSubmit = false;
    }
    return canSubmit;
  }
}
