import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';

class TypingInternalisationScreen extends StatefulWidget {
  @override
  _TypingInternalisationScreenState createState() =>
      _TypingInternalisationScreenState();
}

class _TypingInternalisationScreenState
    extends State<TypingInternalisationScreen> {
  TextEditingController _textController;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _textController = new TextEditingController(text: "");
  }

  Widget buildTextEntry() {
    final vm = Provider.of<InternalisationViewModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 30, top: 20),
      decoration: BoxDecoration(
          // color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.text,
              maxLines: null,
              textInputAction: TextInputAction.done,
              onChanged: (text) {
                setState(() {});
                print("ON CHANGED");
              },
              onSubmitted: (text) {
                setState(() {
                  _done = true;
                });
                if (text.toLowerCase() ==
                    vm.implementationIntention.toLowerCase()) {
                  print("MATCH");
                } else {
                  print("NO MATCH");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildSubmitButton() {
    return SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () => {
            Navigator.pushNamed(
                context, RouteNames.AMBULATORY_ASSESSMENT_PRE_TEST)
          },
          child: Text("Abschicken", style: TextStyle(fontSize: 20)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<InternalisationViewModel>(context, listen: false);
    return Container(
      child: ListView(
        children: <Widget>[
          UIHelper.verticalSpaceMedium(),
          UIHelper.verticalSpaceMedium(),
          Text(vm.implementationIntention,
              style: TextStyle(fontSize: 30.0, color: Colors.grey[900])),
          UIHelper.verticalSpaceMedium(),
          Center(
              child: Text(("Schreibe den Text auf"),
                  style: TextStyle(fontSize: 20.0, color: Colors.grey[900]))),
          UIHelper.verticalSpaceMedium(),
          buildTextEntry(),
          UIHelper.verticalSpaceMedium(),
          if (_done) _buildSubmitButton()
        ],
      ),
    );
  }
}
