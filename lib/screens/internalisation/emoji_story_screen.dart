import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/route_names.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:prompt/viewmodels/internalisation_view_model.dart';
import 'package:prompt/widgets/emoji_keyboard/base_emoji.dart';
import 'package:prompt/widgets/emoji_keyboard/emoji_keyboard_widget.dart';
import 'package:prompt/widgets/full_width_button.dart';
import 'package:prompt/widgets/info_bubble.dart';
import 'package:prompt/widgets/speech_bubble.dart';

class EmojiStoryScreen extends StatefulWidget {
  EmojiStoryScreen({Key key}) : super(key: key);

  @override
  _EmojiStoryScreenState createState() => _EmojiStoryScreenState();
}

class _EmojiStoryScreenState extends State<EmojiStoryScreen> {
  bool _done = false;
  // String _emojiStoryIf = "";
  // String _emojiStoryThen = "";

  final TextEditingController _controllerLeft = TextEditingController();
  final TextEditingController _controllerRight = TextEditingController();
  // bool _useEmojiPicker = false;

  TextEditingController _activeController;

  @override
  void initState() {
    super.initState();
    _activeController = _controllerLeft;
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
                  InfoBubble(
                      text:
                          "Erstelle aus Emojis eine Darstellung deines Planes"),
                  UIHelper.verticalSpaceMedium(),
                  SpeechBubble(text: "'${vm.plan}'"),
                  UIHelper.verticalSpaceMedium(),
                  // buildEmojiFieldsHorizontal(),
                  _buildEmojiPickerCompatibleTextInput(),
                  UIHelper.verticalSpaceMedium(),
                  _buildEmojiPicker(),
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

  _buildEmojiPickerCompatibleTextInput() {
    var width = MediaQuery.of(context).size.width * 0.45;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Wenn...", style: Theme.of(context).textTheme.headline6),
            Container(
                width: width,
                child: Stack(children: [
                  TextField(
                    minLines: 1,
                    maxLines: 2,
                    controller: _controllerLeft,
                    autofocus: true,
                    autocorrect: false,
                    readOnly: true,
                    enableSuggestions: false,
                    enableInteractiveSelection: false,
                    style: Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    onChanged: (text) {
                      setState(() {
                        // _emojiStoryIf = text;
                        // _checkIfIsDone();
                      });
                    },
                    onTap: () {
                      setState(() {
                        _activeController = _controllerLeft;
                        _checkIfIsDone();
                      });
                    },
                  ),
                  Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: IconButton(
                          icon: Icon(Icons.backspace),
                          onPressed: () {
                            _controllerLeft.text = "";
                            _checkIfIsDone();
                          })),
                ])),
          ],
        ),
        // Text("➡", style: Theme.of(context).textTheme.headline6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("dann...", style: Theme.of(context).textTheme.headline6),
            Container(
                width: width,
                child: Stack(children: [
                  TextField(
                    minLines: 1,
                    maxLines: 2,
                    controller: _controllerRight,
                    autofocus: true,
                    autocorrect: false,
                    readOnly: true,
                    enableSuggestions: false,
                    enableInteractiveSelection: false,
                    style: Theme.of(context).textTheme.headline6,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    onChanged: (text) {
                      setState(() {
                        // _emojiStoryThen = text;
                        // _checkIfIsDone();
                      });
                    },
                    onTap: () {
                      setState(() {
                        _activeController = _controllerRight;
                        _checkIfIsDone();
                      });
                    },
                  ),
                  Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: IconButton(
                          icon: Icon(Icons.backspace),
                          onPressed: () {
                            _controllerRight.text = "";
                            _checkIfIsDone();
                          })),
                ])),
          ],
        )
      ],
    );
  }

  _buildEmojiPicker() {
    var emojiKeyboard = EmojiKeyboard(
      onEmojiSelected: (Emoji emoji) {
        setState(() {
          _activeController.text += emoji.text;
        });
        _checkIfIsDone();
      },
    );
    return emojiKeyboard;
  }

  _buildSubmitButton() {
    var vm = Provider.of<InternalisationViewModel>(context, listen: false);
    return Align(
        alignment: Alignment.bottomCenter,
        child: FullWidthButton(
          height: 40,
          onPressed: () async {
            await vm.submit(InternalisationCondition.emoji,
                "Wenn ${_controllerLeft.text} dann ${_controllerRight.text}");
            Navigator.pushNamed(context, RouteNames.NO_TASKS);
          },
        ));
  }

  void _checkIfIsDone() {
    _done = _controllerLeft.text.isNotEmpty && _controllerRight.text.isNotEmpty;
  }
}
