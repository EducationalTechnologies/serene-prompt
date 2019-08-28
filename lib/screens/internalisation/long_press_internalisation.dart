import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:implementation_intentions/shared/app_colors.dart';
import 'package:implementation_intentions/shared/text_styles.dart';
import 'package:implementation_intentions/shared/ui_helpers.dart';
import 'package:implementation_intentions/state/goal_shielding_state.dart';
import 'package:provider/provider.dart';

class LongPressInternalisation extends StatefulWidget {
  @override
  _LongPressInternalisationState createState() =>
      _LongPressInternalisationState();
}

class _LongPressInternalisationState extends State<LongPressInternalisation> {
  int _longPressCounter = 0;
  bool _counterPressed = false;
  bool _loopActive = false;
  int _highlightIndex = 0;

  int _fullTextLength = 0;
  int _repeatCounter = 0;

  buildShieldingText() {
    final intention = Provider.of<GoalShieldingState>(context);

    // List<String> fullText = ["When ", "I ", "start "];

    List<TextSpan> texts = [];

    // for (var i = 0; i < fullText.length; i++) {
    //   texts.add(getRegularText(fullText[i]));
    // }

    // var split = intention.hindrance.split(" ");

    // for (var s in split) {
    //   texts.add(getRegularText("$s "));
    // }

    // texts.add(getRegularText("I "));
    // texts.add(getRegularText("will "));

    if (intention.shieldingSentence == "") {
      return Text("Bitte wähle zunächst ein Lernhindernis aus");
    }

    var splitShieldingActions = intention.shieldingSentence.split(" ");

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

  buildShieldActionTextPart(String shieldText) {
    return TextSpan(text: "$shieldText ");
  }

  getRegularText(String text) {
    return TextSpan(
        text: text,
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25));
  }

  getHighlightedText(String text) {
    return TextSpan(
        text: text,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 27));
  }

  void _increaseCounterWhilePressed() async {
    final int _textHighlightDelay = 400;

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
            width: double.infinity,
            height: 80,
            child: RaisedButton(
              color: accentColor,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(55.0)),
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
              "Wiederhole den nächsten Satz mindestens drei mal:",
              style: subHeaderStyle,
            ),
            UIHelper.verticalSpaceMedium(),
            buildShieldingText(),
            UIHelper.verticalSpaceMedium(),
            buildRepetitionButton(),
            UIHelper.verticalSpaceMedium(),
            // Text("Debug Stuff Counter: $_longPressCounter")
          ],
        ),
      ),
    );
  }
}
