import 'dart:math';

import 'package:flutter/material.dart';

class ScrambleInternalisation extends StatefulWidget {
  @override
  _ScrambleInternalisationState createState() =>
      _ScrambleInternalisationState();
}

class _ScrambleInternalisationState extends State<ScrambleInternalisation> {
  List<String> _sentence = ["This", "Is", "Scrambled", "Text"];

  List<String> _builtSentence = [];

  buildWordBox(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _builtSentence.add(text);
        });
      },
      child: Container(
        child: Text(text),
        color: Colors.yellowAccent[700],
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }

  buildEmptyWord(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _builtSentence.add(text);
        });
      },
      child: Container(
        child: Opacity(opacity: 0, child: Text(text)),
        color: Colors.grey[600],
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(9.0),
      ),
    );
  }

  scrambleSentence(List<String> sentence) {
    var random = new Random();

    for (var i = sentence.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);

      var temp = sentence[i];
      sentence[i] = sentence[n];
      sentence[n] = temp;
    }

    return sentence;
  }

  @override
  Widget build(BuildContext context) {
    this._sentence = scrambleSentence(_sentence);
    return Container(
      child: Column(
        children: <Widget>[
          Wrap(
            children: <Widget>[
              for (var s in _builtSentence) buildWordBox(s),
            ],
          ),
          Wrap(
            children: <Widget>[
              for (var s in _sentence)
                Stack(children: [buildEmptyWord(s), buildWordBox(s)])
            ],
          ),
        ],
      ),
    );
  }
}
