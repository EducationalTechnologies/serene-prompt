import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
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

  String _ifPart = "";
  String _thenPart = "";

  void _checkIfIsDone() {
    _done = _ifPart.isNotEmpty && _thenPart.isNotEmpty;
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
                  buildInputBoxes()
                ],
              ),
            ),
            if (_done) _buildSubmitButton()
          ],
        ),
      ),
    );
  }

  buildInputBoxes() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Wenn...", style: Theme.of(context).textTheme.headline6),
      Center(
          child: TextField(
        minLines: 1,
        maxLines: 2,
        autofocus: true,
        autocorrect: false,
        enableSuggestions: false,
        style: Theme.of(context).textTheme.headline6,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        onChanged: (text) {
          setState(() {
            _ifPart = text;
            _checkIfIsDone();
          });
        },
      )),
      Text("dann...", style: Theme.of(context).textTheme.headline6),
      Center(
          child: TextField(
        minLines: 1,
        maxLines: 2,
        autofocus: true,
        autocorrect: false,
        enableSuggestions: false,
        style: Theme.of(context).textTheme.headline6,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        onChanged: (text) {
          setState(() {
            _thenPart = text;
            _checkIfIsDone();
          });
        },
      )),
    ]);
  }

  _buildSubmitButton() {
    var vm =
        Provider.of<InternalisationRecallViewModel>(context, listen: false);
    return Align(
        alignment: Alignment.bottomCenter,
        child: FullWidthButton(
          onPressed: () async {
            var recalledText = "Wenn $_ifPart dann $_thenPart";
            vm.submit(recalledText);
          },
        ));
  }
}
