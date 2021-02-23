import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/viewmodels/ambulatory_assessment_view_model.dart';
import 'package:serene/widgets/interval_scale.dart';
import 'package:provider/provider.dart';

class AmbulatoryAssessmentScreen extends StatelessWidget {
  _submit(BuildContext context) async {
    var vm = Provider.of<AmbulatoryAssessmentViewModel>(context, listen: false);
    await vm.submit();
  }

  _buildAssessmentList(BuildContext context) {
    var vm = Provider.of<AmbulatoryAssessmentViewModel>(context);
    var assessment = vm.currentAssessment;
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
          for (var index = 0; index < assessment.length; index++)
            Card(
                child: Padding(
              padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
              child: IntervalScale(
                title: assessment[index].title,
                itemCount: assessment[index].itemCount,
                labels: assessment[index].labels,
                id: assessment[index].id,
                groupValue: vm.getResultForIndex(index),
                callback: (val) {
                  print("Changed Assessment value to: $val");
                  vm.setResult(assessment[index].id, val);
                },
              ),
            )),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: RaisedButton(
                onPressed: canSubmit ? () async => _submit(context) : null,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                child: Text("Speichern", style: TextStyle(fontSize: 20)),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<AmbulatoryAssessmentViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(vm.title),
      ),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildAssessmentList(context)),
      ),
    );
  }
}
