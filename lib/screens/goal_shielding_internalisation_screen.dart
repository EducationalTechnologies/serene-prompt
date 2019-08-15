import 'package:flutter/material.dart';
import 'package:implementation_intentions/shared/text_styles.dart';
import 'package:implementation_intentions/shared/ui_helpers.dart';
import 'package:implementation_intentions/state/goal_shielding_state.dart';
import 'package:provider/provider.dart';

class GoalShieldingInternalisationScreen extends StatefulWidget {
  @override
  _GoalShieldingInternalisationScreenState createState() =>
      _GoalShieldingInternalisationScreenState();
}

class _GoalShieldingInternalisationScreenState
    extends State<GoalShieldingInternalisationScreen> {
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
    final intention = Provider.of<GoalShieldingState>(context);

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

    var splitShieldingActions =
        intention.selectedShieldingActions.join().split(" ");

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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            UIHelper.verticalSpaceMedium(),
            Text(
              "Wiederhole den nächsten Satz mindestens drei mal",
              style: subHeaderStyle,
            ),
            UIHelper.verticalSpaceMedium(),
            buildShieldingText(),
            UIHelper.verticalSpaceMedium(),
            buildRepetitionButton(),
            UIHelper.verticalSpaceMedium(),
            Text("Halte den Button gedrückt während du den Satz wiederholst")
            // Text("Debug Stuff Counter: $_longPressCounter")
          ],
        ),
      ),
    );
  }
}
