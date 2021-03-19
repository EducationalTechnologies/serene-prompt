import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';
import 'package:serene/widgets/speech_bubble.dart';

class ScrambleText {
  int originalPosition;
  bool isSelected;
  String text;

  ScrambleText({this.originalPosition, this.isSelected, this.text});

  static randomizeList(List list) {
    var random = new Random();
    for (var i = list.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);

      var temp = list[i];
      list[i] = list[n];
      list[n] = temp;
    }

    return list;
  }

  static List<ScrambleText> scrambleTextListFromString(String text, int step) {
    List<ScrambleText> output = [];
    var shieldSentence = text.split(" ");
    var index = 0;
    while (index < shieldSentence.length) {
      var sentenceChunk = "";
      for (var j = 0; j < step; j++) {
        if ((index + j) < (shieldSentence.length)) {
          sentenceChunk += shieldSentence[index + j];
        }
        // Add whitespace except for the last character to not have trailing whitespace
        if ((index + j) < shieldSentence.length - 1) {
          sentenceChunk += " ";
        }
      }
      index += step;
      var st = ScrambleText(
          isSelected: false, text: sentenceChunk, originalPosition: 0);
      output.add(st);
    }
    return output;
  }

  static String stringFromScrambleTextList(List<ScrambleText> list) {
    return list.map((st) => st.text).toList().join();
  }
}

class ScrambleInternalisation extends StatefulWidget {
  final bool showText;

  const ScrambleInternalisation(this.showText);

  @override
  _ScrambleInternalisationState createState() =>
      _ScrambleInternalisationState();
}

class _ScrambleInternalisationState extends State<ScrambleInternalisation> {
  List<ScrambleText> _scrambledSentence = [];
  String _correctSentence = "";
  List<ScrambleText> _builtSentence = [];
  bool _done = false;
  Duration fadeOutDuration = Duration(seconds: 15);
  bool _showPlan = true;
  bool _showPuzzle = false;

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      var vm = Provider.of<InternalisationViewModel>(context, listen: false);
      _correctSentence = _cleanInputString(vm.implementationIntention);
      setState(() {
        _scrambledSentence = ScrambleText.randomizeList(
            ScrambleText.scrambleTextListFromString(_correctSentence, 1));
      });

      if (widget.showText) {
        Timer(Duration(seconds: 5), () {
          setState(() {
            _showPlan = false;
            _showPuzzle = true;
          });
        });
      }
    });
  }

  String _cleanInputString(String input) {
    return input.replaceAll("**", "").replaceAll("#", "");
  }

  _isDone() {
    var built = ScrambleText.stringFromScrambleTextList(_builtSentence);
    return built == _correctSentence;
  }

  _allChunksUsed() {
    var selectedScramble = _scrambledSentence
        .firstWhere((element) => !element.isSelected, orElse: () => null);

    return selectedScramble == null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                UIHelper.verticalSpaceMedium(),
                _buildCorrectText(_correctSentence),
                UIHelper.verticalSpaceMedium(),
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Wrap(
                    children: <Widget>[
                      for (var s in _builtSentence)
                        if (s.isSelected) buildWordBox(s),
                    ],
                  ),
                ),
                Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: _builtSentence.length > 0,
                  child: _buildDeleteButton(),
                ),

                // _buildDragDrop(),
                if (_allChunksUsed() && !_isDone()) _buildIncorrectWarning(),

                Visibility(
                  visible: _showPuzzle,
                  child: Wrap(
                    children: <Widget>[
                      for (var s in _scrambledSentence)
                        if (!s.isSelected)
                          Stack(children: [
                            buildEmptyWord(s.text),
                            buildWordBox(s)
                          ])
                        else
                          buildEmptyWord(s.text)
                    ],
                  ),
                ),
                UIHelper.verticalSpaceLarge(),
              ],
            ),
          ),
          if (_isDone()) _buildSubmitButton()
        ],
      ),
    );
  }

  buildWordBox(ScrambleText scramble) {
    return GestureDetector(
      onTap: () {
        // _builtSentence.add(scramble);
        _scrambleTextClick(scramble);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.orange[200],
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 0.5)]),
        child: Text(
          scramble.text,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        margin: EdgeInsets.all(1.0),
        padding: EdgeInsets.all(6.0),
      ),
    );
  }

  _scrambleTextClick(ScrambleText scramble) {
    setState(() {
      scramble.isSelected = !scramble.isSelected;
      if (scramble.isSelected) {
        _builtSentence.add(scramble);
        print(scramble.isSelected);
        setState(() {
          _done = _isDone();
        });
      } else {
        _builtSentence.remove(scramble);
      }
    });
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
        margin: EdgeInsets.all(1.0),
        padding: EdgeInsets.all(6.0),
      ),
    );
  }

  _buildDeleteButton() {
    return Container(
      width: 90,
      child: OutlinedButton(
          child: Row(
            children: [
              Icon(Icons.backspace),
              UIHelper.horizontalSpaceMedium(),
              Text(
                "Letzte Eingabe Löschen",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
          onPressed: () {
            setState(() {
              if (_builtSentence.length > 0) {
                var last = _builtSentence.last;
                _scrambleTextClick(last);
              }
            });
          }),
    );
  }

  _buildSubmitButton() {
    var vm = Provider.of<InternalisationViewModel>(context, listen: false);
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () async {
              var condition = InternalisationCondition.scrambleWithHint;
              vm.submit(condition, "");
            },
            child: Text("Abschicken", style: TextStyle(fontSize: 20)),
          )),
    );
  }

  _buildCorrectText(String text) {
    return AnimatedOpacity(
        opacity: this._showPlan ? 1.0 : 0.0,
        duration: Duration(seconds: 1),
        child: Column(
          children: [
            Text(
              "Merke dir folgenden Text, und Puzzle ihn dann gleich zusammen:",
              style: Theme.of(context).textTheme.headline6,
            ),
            UIHelper.verticalSpaceMedium(),
            SpeechBubble(text: text),
          ],
        ));
  }

  _buildIncorrectWarning() {
    return Container(
      color: Colors.red[200],
      child: Center(
          child: (Text(
        "Der gebaute Satz ist leider nicht richtig",
        style: TextStyle(fontSize: 20),
      ))),
      margin: EdgeInsets.fromLTRB(2, 10, 2, 20),
      padding: EdgeInsets.fromLTRB(2, 10, 2, 10),
    );
  }

  buildPuzzle() {
    return Wrap(
      children: <Widget>[
        for (var s in _scrambledSentence)
          if (!s.isSelected)
            Stack(children: [buildEmptyWord(s.text), buildWordBox(s)])
          else
            buildEmptyWord(s.text)
      ],
    );
  }
}
