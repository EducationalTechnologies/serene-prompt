import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:prompt/viewmodels/internalisation_view_model.dart';
import 'package:prompt/widgets/full_width_button.dart';
import 'package:prompt/widgets/speech_bubble.dart';

class WritingInternalisation extends StatefulWidget {
  WritingInternalisation({Key key}) : super(key: key);

  @override
  _WritingInternalisationState createState() => _WritingInternalisationState();
}

class _WritingInternalisationState extends State<WritingInternalisation> {
  bool _done = false;

  _buildSubmitButton() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: FullWidthButton(
          onPressed: () async {
            // await vm.submit(InternalisationCondition.);
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
                  style: Theme.of(context).textTheme.headline6,
                ),
                UIHelper.verticalSpaceMedium(),
                SpeechBubble(text: "'${vm.plan}'"),
                UIHelper.verticalSpaceMedium(),
                Center(
                    child: TextField(
                  minLines: 3,
                  maxLines: 5,
                  autocorrect: false,
                  enableSuggestions: false,
                  style: Theme.of(context).textTheme.headline5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: ""),
                  onChanged: (text) {
                    setState(() {
                      _done = true;
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
