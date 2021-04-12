import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prompt/models/assessment.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:prompt/viewmodels/ambulatory_assessment_view_model.dart';
import 'package:prompt/widgets/full_width_button.dart';
import 'package:prompt/widgets/interval_scale.dart';
import 'package:provider/provider.dart';

class AmbulatoryAssessmentScreen extends StatelessWidget {
  _submit(BuildContext context) async {
    var vm = Provider.of<AmbulatoryAssessmentViewModel>(context, listen: false);
    await vm.submit();
  }

  _buildAssessmentList(BuildContext context, Assessment assessment) {
    var vm = Provider.of<AmbulatoryAssessmentViewModel>(context);
    // var assessment = vm.currentAssessment;
    var canSubmit = vm.canSubmit();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Card(
              child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    vm.preText,
                    textAlign: TextAlign.center,
                    style: (TextStyle(fontSize: 18)),
                  ))),
          UIHelper.verticalSpaceMedium(),
          Text("Bitte beantworte die folgenden Fragen: "),
          UIHelper.verticalSpaceMedium(),
          for (var index = 0; index < assessment.items.length; index++)
            Card(
                child: Padding(
              padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
              child: IntervalScale(
                title: assessment.items[index].title,
                labels: assessment.items[index].labels,
                id: assessment.items[index].id,
                groupValue: vm.getResultForIndex(index),
                callback: (val) {
                  print("Changed Assessment value to: $val");
                  vm.setResult(assessment.items[index].id, val);
                },
              ),
            )),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: FullWidthButton(
                onPressed: canSubmit ? () async => _submit(context) : null,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<AmbulatoryAssessmentViewModel>(context);
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text("Bitte beantworte die folgenden Fragen:"),
      // ),
      body: Container(
        child: FutureBuilder(
            future: vm.getAssessment(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Assessment ass = snapshot.data;
                return _buildAssessmentList(context, ass);
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
