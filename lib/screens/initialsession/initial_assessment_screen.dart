import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';
import 'package:serene/widgets/interval_scale.dart';
import 'package:async/async.dart';

class InitialAssessmentScreen extends StatelessWidget {
  final AssessmentTypes assessmentType;
  final VoidCallback onFinished;
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  InitialAssessmentScreen(this.assessmentType, this.onFinished) : super();

  @override
  Widget build(BuildContext context) {
    return Container(child: _buildAssessmentList(context));
  }

  _fetchAssessment(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);
    return this._memoizer.runOnce(() async {
      return await vm.getAssessment(assessmentType);
    });
  }

  _buildAssessmentList(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);
    return FutureBuilder(
        future: _fetchAssessment(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var questions = snapshot.data.items;
            var title = snapshot.data.title;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                      child: Container(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: (TextStyle(fontSize: 18)),
                        )),
                  )),
                  for (var index = 0; index < questions.length; index++)
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: IntervalScale(
                            title: questions[index].title,
                            labels: questions[index].labels,
                            id: questions[index].id,
                            // groupValue: vm.getResultForIndex(index),
                            callback: (val) {
                              print("Changed Assessment value to: $val");
                              vm.setAssessmentResult(this.assessmentType,
                                  questions[index].id, val);
                              this.onFinished();
                              // vm.setResult(assessment[index].id, val);
                            },
                          ),
                        )),
                  UIHelper.verticalSpaceMedium(),
                  Visibility(
                    visible: !vm.canMoveNext(),
                    child: Text(
                        "Du hast noch nicht alle Fragen beantwortet. Sobald du für alle Fragen eine Auswahl getroffen hast, kannst du weiter zum nächsten Schritt"),
                  )
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
