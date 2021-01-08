import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/internalisation_recall_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';

class InternalisationRecallScreen extends StatefulWidget {
  InternalisationRecallScreen({Key key}) : super(key: key);

  @override
  _InternalisationRecallScreenState createState() =>
      _InternalisationRecallScreenState();
}

class _InternalisationRecallScreenState
    extends State<InternalisationRecallScreen> {
  bool _done = false;
  String _recalledText;

  _buildSubmitButton() {
    var vm =
        Provider.of<InternalisationRecallViewModel>(context, listen: false);
    return Align(
        alignment: Alignment.bottomCenter,
        child: FullWidthButton(
          onPressed: () async {
            await vm.submit(_recalledText);
            Navigator.pushNamed(context, RouteNames.NO_TASKS);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: UIHelper.getContainerMargin(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView(
                children: [
                  UIHelper.verticalSpaceMedium(),
                  Text(
                    "Schreibe deinen Wenn-Dann-Plan so auf, wie du dich an ihn erinnerst",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  UIHelper.verticalSpaceMedium(),
                  Center(
                      child: TextField(
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Gib hier deinen Wenn-Dann-Plan ein"),
                    onChanged: (text) {
                      setState(() {
                        _done = true;
                        _recalledText = text;
                      });
                    },
                  )),
                ],
              ),
            ),
            if (_done) _buildSubmitButton()
          ],
        ),
      ),
    );
  }
}
