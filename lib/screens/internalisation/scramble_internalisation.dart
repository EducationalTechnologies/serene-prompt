import 'dart:math';
import 'package:flutter/material.dart';
import 'package:serene/viewmodels/goal_shielding_state.dart';
import 'package:provider/provider.dart';

class ScrambleText {
  int originalPosition;
  bool isSelected;
  String text;

  ScrambleText({this.originalPosition, this.isSelected, this.text});
}

class ScrambleInternalisation extends StatefulWidget {
  @override
  _ScrambleInternalisationState createState() =>
      _ScrambleInternalisationState();
}

class _ScrambleInternalisationState extends State<ScrambleInternalisation> {
  List<ScrambleText> _sentence = [
    ScrambleText(originalPosition: 0, isSelected: false, text: "This"),
    ScrambleText(originalPosition: 1, isSelected: false, text: "Is"),
    ScrambleText(originalPosition: 2, isSelected: false, text: "Scrambled"),
    ScrambleText(originalPosition: 3, isSelected: false, text: "Text"),
  ];

  List<ScrambleText> _builtSentence = [];

  @override
  initState() {
    super.initState();
    // this._sentence = scrambleSentence(_sentence);
    Future.delayed(Duration.zero, () {
      var shieldState = Provider.of<GoalShieldingState>(context);
      print("ShieldState");
      _sentence = [];
      var shieldSentence = shieldState.shieldingSentence.split(" ");
      for (var i = 0; i < shieldSentence.length; i++) {
        _sentence.add(ScrambleText(
            isSelected: false, text: shieldSentence[i], originalPosition: i));
      }
      setState(() {
        _sentence = scrambleSentence(_sentence);
      });
    });
  }

  buildWordBox(ScrambleText scramble) {
    return GestureDetector(
      onTap: () {
        _builtSentence.add(scramble);
        setState(() {
          scramble.isSelected = !scramble.isSelected;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.yellowAccent[700],
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(1, 1), blurRadius: 1.0)
            ]),
        child: Text(scramble.text),
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  buildEmptyWord(String text) {
    return GestureDetector(
      onTap: () {
        // setState(() {
        //   _builtSentence.add(text);
        // });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[600],
        ),
        child: Opacity(opacity: 0, child: Text(text)),
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(9.0),
      ),
    );
  }

  scrambleSentence(List sentence) {
    var random = new Random();

    for (var i = sentence.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);

      var temp = sentence[i];
      sentence[i] = sentence[n];
      sentence[n] = temp;
    }

    return sentence;
  }

  buildSelectStack() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
            child: Wrap(
              children: <Widget>[
                for (var s in _sentence) if (s.isSelected) buildWordBox(s),
              ],
            ),
          ),
          Wrap(
            children: <Widget>[
              for (var s in _sentence)
                if (!s.isSelected)
                  Stack(children: [buildEmptyWord(s.text), buildWordBox(s)])
                else
                  buildEmptyWord(s.text)
            ],
          ),
        ],
      ),
    );
  }
}
