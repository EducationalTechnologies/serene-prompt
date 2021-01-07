import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';

class ScrambleText {
  int originalPosition;
  bool isSelected;
  String text;

  ScrambleText({this.originalPosition, this.isSelected, this.text});

  static scrambleSentence(List sentence) {
    var random = new Random();
    for (var i = sentence.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);

      var temp = sentence[i];
      sentence[i] = sentence[n];
      sentence[n] = temp;
    }

    return sentence;
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

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      var vm = Provider.of<InternalisationViewModel>(context, listen: false);
      _correctSentence = vm.implementationIntention;
      setState(() {
        _scrambledSentence = ScrambleText.scrambleSentence(
            ScrambleText.scrambleTextListFromString(_correctSentence, 3));
      });
    });
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

  buildWordBox(ScrambleText scramble) {
    return GestureDetector(
      onTap: () {
        // _builtSentence.add(scramble);
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
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black, offset: Offset(2, 2), blurRadius: 4.0)
            ]),
        child: Text(scramble.text),
        margin: EdgeInsets.all(4.0),
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
        margin: EdgeInsets.all(4.0),
        padding: EdgeInsets.all(9.0),
      ),
    );
  }

  buildSelectStack() {}

  _buildSubmitButton() {
    var vm = Provider.of<InternalisationViewModel>(context, listen: false);
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
          width: double.infinity,
          height: 60,
          child: RaisedButton(
            onPressed: () async {
              var condition = widget.showText
                  ? InternalisationCondition.scrambleWithHint
                  : InternalisationCondition.scrambleWithoutHint;
              await vm.submit(condition);
              Navigator.pushNamed(
                  context, RouteNames.AMBULATORY_ASSESSMENT_PRE_TEST);
            },
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            child: Text("Abschicken", style: TextStyle(fontSize: 20)),
          )),
    );
  }

  _buildCorrectText(String text) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 10, 5, 20),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                UIHelper.verticalSpaceMedium(),
                if (this.widget.showText) _buildCorrectText(_correctSentence),
                UIHelper.verticalSpaceMedium(),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: Wrap(
                    children: <Widget>[
                      for (var s in _builtSentence)
                        if (s.isSelected) buildWordBox(s),
                    ],
                  ),
                ),
                // _buildDragDrop(),
                if (_allChunksUsed() && !_isDone()) _buildIncorrectWarning(),
                Wrap(
                  children: <Widget>[
                    for (var s in _scrambledSentence)
                      if (!s.isSelected)
                        Stack(
                            children: [buildEmptyWord(s.text), buildWordBox(s)])
                      else
                        buildEmptyWord(s.text)
                  ],
                ),
              ],
            ),
          ),
          if (_done) _buildSubmitButton()
        ],
      ),
    );
  }
}
