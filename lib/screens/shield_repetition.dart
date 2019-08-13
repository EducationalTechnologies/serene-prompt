import 'package:flutter/material.dart';
import 'package:implementation_intentions/models/implementation_intention_state.dart';
import 'package:implementation_intentions/shared/text_styles.dart';
import 'package:implementation_intentions/shared/ui_helpers.dart';
import 'package:provider/provider.dart';

class ShieldRepetition extends StatefulWidget {
  @override
  _ShieldRepetitionState createState() => _ShieldRepetitionState();
}

class _ShieldRepetitionState extends State<ShieldRepetition> {
  int _longPressCounter = 0;
  bool _counterPressed = false;
  bool _loopActive = false;
  int _highlightIndex = 0;

  int _fullTextLength = 0;
  int _repeatCounter = 0;

  buildShieldActionTextPart(String shieldText) {
    return TextSpan(text: "$shieldText ");
  }

  getRegularText(String text) {
    return TextSpan(
        text: text,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20));
  }

  getHighlightedText(String text) {
    return TextSpan(
        text: text,
        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20));
  }

  buildShieldingText() {
    final intention = Provider.of<ImplementationIntentionState>(context);

    List<String> fullText = ["When ", "I ", "start "];

    List<TextSpan> texts = [];

    for (var i = 0; i < fullText.length; i++) {
      texts.add(getRegularText(fullText[i]));
    }

    var split = intention.hindrance.split(" ");

    for (var s in split) {
      texts.add(getRegularText("$s "));
    }

    texts.add(getRegularText("I "));
    texts.add(getRegularText("will "));

    var splitShieldingActions = intention.shieldingActions.join().split(" ");

    for (var s in splitShieldingActions) {
      texts.add(getRegularText("$s "));
    }

    texts[_highlightIndex] = getHighlightedText(texts[_highlightIndex].text);

    _fullTextLength = texts.length;

    return RichText(
        text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[...texts]));
  }

  void _increaseCounterWhilePressed() async {
    final int _textHighlightDelay = 200;

    // make sure that only one loop is active
    if (_loopActive) return;

    _loopActive = true;

    while (_counterPressed) {
      // do your thing
      setState(() {
        _longPressCounter++;
        _highlightIndex = _longPressCounter % _fullTextLength;
      });

      // wait a bit
      if (_highlightIndex == _fullTextLength - 1) {
        setState(() {
          _repeatCounter++;
        });
        break;
      }
      await Future.delayed(Duration(milliseconds: _textHighlightDelay));
    }

    _loopActive = false;
  }

  buildRepetitionButton() {
    return GestureDetector(
        onLongPressStart: (details) {
          _counterPressed = true;
          _increaseCounterWhilePressed();
        },
        // onLongPress: () {
        //   _counterPressed = true;
        //   _increaseCounterWhilePressed();
        // },
        onLongPressEnd: (details) {
          _counterPressed = false;
        },
        child: SizedBox(
            width: 250,
            height: 80,
            child: RaisedButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0)),
              child: Text("$_repeatCounter", style: TextStyle(fontSize: 20)),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          UIHelper.verticalSpaceMedium(),
          Text(
            "Repeat the following text mentally three times, while pressing the button",
            style: subHeaderStyle,
          ),
          UIHelper.verticalSpaceMedium(),
          buildShieldingText(),
          UIHelper.verticalSpaceMedium(),
          buildRepetitionButton(),
          // Text("Debug Stuff Counter: $_longPressCounter")
        ],
      ),
    );
  }
}
