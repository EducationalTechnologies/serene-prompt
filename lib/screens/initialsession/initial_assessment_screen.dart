import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';
import 'package:serene/widgets/interval_scale.dart';

class InitialAssessmentScreen extends StatelessWidget {
  final AssessmentTypes assessmentType;

  const InitialAssessmentScreen(this.assessmentType, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: _buildAssessmentList(context));
  }

  _buildAssessmentList(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);
    return FutureBuilder(
        future: vm.getAssessment(assessmentType),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var questions = snapshot.data.items;
            var title = snapshot.data.title;
            var assessmentId = snapshot.data.id;
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
                              // vm.setResult(assessment[index].id, val);
                            },
                          ),
                        )),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
