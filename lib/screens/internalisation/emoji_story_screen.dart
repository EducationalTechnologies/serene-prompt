import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';

class EmojiStoryScreen extends StatefulWidget {
  EmojiStoryScreen({Key key}) : super(key: key);

  @override
  _EmojiStoryScreenState createState() => _EmojiStoryScreenState();
}

class _EmojiStoryScreenState extends State<EmojiStoryScreen> {
  bool _done = false;
  String _emojiStory = "";

  // bool _useEmojiPicker = false;

  _buildSubmitButton() {
    var vm = Provider.of<InternalisationViewModel>(context, listen: false);
    return Align(
        alignment: Alignment.bottomCenter,
        child: FullWidthButton(
          onPressed: () async {
            await vm.submitEmojiStory(_emojiStory);
            Navigator.pushNamed(context, RouteNames.NO_TASKS);
          },
        ));
  }

  // _buildEmojiPicker() {
  //   return EmojiKeyboard(
  //     onEmojiSelected: (Emoji emoji) {
  //       setState(() {
  //         _emojiStory += emoji.text;
  //       });
  //       print(emoji);
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<InternalisationViewModel>(context);
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
                    "Erstelle aus Emojis eine Darstellung deines Wenn-Dann-Planes:",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  UIHelper.verticalSpaceMedium(),
                  Text(
                    "'${vm.implementationIntention}'",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  UIHelper.verticalSpaceMedium(),
                  Center(
                      child: TextField(
                    minLines: 3,
                    maxLines: 5,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: Theme.of(context).textTheme.headline5,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Gib hier deine Emoji-Repräsentation ein"),
                    onChanged: (text) {
                      setState(() {
                        _done = true;
                        _emojiStory = text;
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
      ),
    );
  }
}
