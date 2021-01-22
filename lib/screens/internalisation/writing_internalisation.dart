import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';

class WritingInternalisation extends StatefulWidget {
  WritingInternalisation({Key key}) : super(key: key);

  @override
  _WritingInternalisationState createState() => _WritingInternalisationState();
}

class _WritingInternalisationState extends State<WritingInternalisation> {
  bool _done = false;
  String _iiText = "";

  _buildSubmitButton() {
    var vm = Provider.of<InternalisationViewModel>(context, listen: false);
    return Align(
        alignment: Alignment.bottomCenter,
        child: FullWidthButton(
          onPressed: () async {
            await vm.submit(InternalisationCondition.writing);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<InternalisationViewModel>(context);
    return Container(
      margin: UIHelper.getContainerMargin(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              children: [
                UIHelper.verticalSpaceMedium(),
                Text(
                  "Schreibe den folgenden Plan auf:",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  vm.implementationIntention,
                  style: Theme.of(context).textTheme.headline5,
                ),
                UIHelper.verticalSpaceMedium(),
                Center(
                    child: TextField(
                  minLines: 3,
                  maxLines: 5,
                  autocorrect: false,
                  enableSuggestions: false,
                  style: TextStyle(fontSize: 30),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: ""),
                  onChanged: (text) {
                    setState(() {
                      _done = true;
                      _iiText = text;
                    });
                  },
                )),
                UIHelper.verticalSpaceMedium(),
                // _buildSubmitButton(),
                UIHelper.verticalSpaceMedium(),
              ],
            ),
          ),
          if (_done) _buildSubmitButton()
        ],
      ),
    );
  }
}
