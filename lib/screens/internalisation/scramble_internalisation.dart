import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/viewmodels/goal_shielding_view_model.dart';

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
  List<ScrambleText> _scrambledSentence = [];

  List<ScrambleText> _builtSentence = [];

  @override
  initState() {
    super.initState();
    // this._sentence = scrambleSentence(_sentence);
    Future.delayed(Duration.zero, () {
      var shieldState = Provider.of<GoalShieldingViewModel>(context);
      print("ShieldState");
      _scrambledSentence = [];
      var shieldSentence = shieldState.selectedShieldingAction.split(" ");
      var step = 3;
      var index = 0;
      while (index < shieldSentence.length) {
        var sentenceChunk = "";
        for (var j = 0; j < step; j++) {
          if ((index + j) < (shieldSentence.length)) {
            sentenceChunk += shieldSentence[index + j] + " ";
          }
        }
        index += step;
        var st = ScrambleText(
            isSelected: false, text: sentenceChunk, originalPosition: 0);
        _scrambledSentence.add(st);
        _builtSentence.add(st);
      }
      setState(() {
        _scrambledSentence = scrambleSentence(_scrambledSentence);
      });
    });
  }

  buildWordBox(ScrambleText scramble) {
    return GestureDetector(
      onTap: () {
        // _builtSentence.add(scramble);
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
            height: MediaQuery.of(context).size.height / 3,
            child: Wrap(
              children: <Widget>[
                for (var s in _builtSentence) if (s.isSelected) buildWordBox(s),
              ],
            ),
          ),
          Wrap(
            children: <Widget>[
              for (var s in _scrambledSentence)
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
