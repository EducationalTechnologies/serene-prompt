import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';
import 'package:serene/widgets/interval_scale.dart';

class InitialAssessmentScreen extends StatelessWidget {
  final Assessments assessment;

  const InitialAssessmentScreen(this.assessment, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: _buildAssessmentList(context));
  }

  _buildAssessmentList(BuildContext context) {
    var questions =
        Provider.of<InitSessionViewModel>(context).getAssessment(assessment);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Card(
              child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Initiales Assessment",
                    textAlign: TextAlign.center,
                    style: (TextStyle(fontSize: 18)),
                  ))),
          for (var index = 0; index < questions.length; index++)
            Card(
                child: Padding(
              padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
              child: IntervalScale(
                title: questions[index].title,
                labels: questions[index].labels,
                id: questions[index].id,
                // groupValue: vm.getResultForIndex(index),
                // callback: (val) {
                //   print("Changed Assessment value to: $val");
                //   vm.setResult(assessment[index].id, val);
                // },
              ),
            )),
        ],
      ),
    );
  }
}
