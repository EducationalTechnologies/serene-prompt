import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_emoji_keyboard/flutter_emoji_keyboard.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';
import 'package:serene/widgets/speech_bubble.dart';

class EmojiStoryScreen extends StatefulWidget {
  EmojiStoryScreen({Key key}) : super(key: key);

  @override
  _EmojiStoryScreenState createState() => _EmojiStoryScreenState();
}

class _EmojiStoryScreenState extends State<EmojiStoryScreen> {
  bool _done = false;
  String _emojiStoryIf = "";
  String _emojiStoryThen = "";

  // bool _useEmojiPicker = false;

  _buildSubmitButton() {
    var vm = Provider.of<InternalisationViewModel>(context, listen: false);
    return Align(
        alignment: Alignment.bottomCenter,
        child: FullWidthButton(
          onPressed: () async {
            await vm.submit(InternalisationCondition.emoji,
                "Wenn $_emojiStoryIf dann $_emojiStoryThen");
            Navigator.pushNamed(context, RouteNames.NO_TASKS);
          },
        ));
  }

  void _checkIfIsDone() {
    _done = _emojiStoryIf.isNotEmpty && _emojiStoryThen.isNotEmpty;
  }

  _buildEmojiPicker() {
    return EmojiKeyboard(
      onEmojiSelected: (Emoji emoji) {
        setState(() {
          _emojiStoryIf += emoji.text;
        });
        print(emoji);
      },
    );
  }

  buildEmojiFieldsHorizontal() {
    var width = MediaQuery.of(context).size.width * 0.4;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text("Wenn..."),
            Container(
                width: width,
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
                      _emojiStoryIf = text;
                      _checkIfIsDone();
                    });
                  },
                )),
          ],
        ),
        Text("➡", style: Theme.of(context).textTheme.headline6),
        Column(
          children: [
            Text("dann..."),
            Container(
                width: width,
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
                      _emojiStoryThen = text;
                      _checkIfIsDone();
                    });
                  },
                )),
          ],
        )
      ],
    );
  }

  buildEmojiFieldsVertical() {
    return Column(children: [
      Text("Wenn ich..."),
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
            _emojiStoryIf = text;
            _checkIfIsDone();
          });
        },
      )),
      Text("dann..."),
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
            _emojiStoryThen = text;
            _checkIfIsDone();
          });
        },
      )),
    ]);
  }

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
                  SpeechBubble(text: "'${vm.implementationIntention}'"),
                  UIHelper.verticalSpaceMedium(),
                  buildEmojiFieldsHorizontal(),
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
