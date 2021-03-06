import 'package:flutter/material.dart';
import 'package:prompt/models/assessment.dart';
import 'package:prompt/models/assessment_item.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:prompt/widgets/interval_scale.dart';

typedef void ItemSelectedCallback(
    String assessment, String itemId, String value);

typedef void OnLoadedCallback(Assessment assessment);

class Questionnaire extends StatefulWidget {
  final Assessment assessment;
  final ItemSelectedCallback onFinished;
  final OnLoadedCallback onLoaded;
  const Questionnaire(this.assessment, this.onFinished,
      {this.onLoaded, Key key})
      : super(key: key);

  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  Map<String, String> _results = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.onLoaded != null) {
      widget.onLoaded(widget.assessment);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.assessment.title);
    if (widget.assessment == null)
      return Container(child: CircularProgressIndicator());
    return Scrollbar(
      thickness: 8.0,
      isAlwaysShown: true,
      child: ListView(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        shrinkWrap: true,
        children: <Widget>[
          Visibility(
            visible: widget.assessment.title.isNotEmpty,
            child: Card(
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
          ),
          for (var index = 0; index < widget.assessment.items.length; index++)
            buildQuestionCard(widget.assessment.items[index], index),
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

  buildQuestionCard(AssessmentItemModel assessment, int index) {
    var groupValue = -1;
    if (_results.containsKey(widget.assessment.items[index].id)) {
      groupValue = int.tryParse(_results[widget.assessment.items[index].id]);
      if (groupValue == null) {
        groupValue = -1;
      }
    }

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: IntervalScale(
            title: assessment.title,
            labels: assessment.labels,
            id: assessment.id,
            groupValue: groupValue,
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
        ));
  }

  bool _isFilledOut() {
    bool canSubmit = true;
    for (var assessmentItem in widget.assessment.items) {
      if (!_results.containsKey(assessmentItem.id)) canSubmit = false;
    }
    return canSubmit;
  }
}
