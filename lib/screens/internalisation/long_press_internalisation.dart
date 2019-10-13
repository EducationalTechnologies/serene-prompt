import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/state/goal_shielding_state.dart';
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
              onPressed: () {},
              child: Text("$_repeatCounter", style: TextStyle(fontSize: 20)),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final intention = Provider.of<GoalShieldingState>(context);

    return Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                UIHelper.verticalSpaceMedium(),
                // Text(
                //   "Wiederhole den nächsten Satz mindestens drei mal:",
                //   style: subHeaderStyle,
                // ),
                // UIHelper.verticalSpaceMedium(),
                // buildShieldingText(),
                UIHelper.verticalSpaceMedium(),
                // buildRepetitionButton(),
                TextHighlight(
                  text: intention.shieldingSentence,
                  wpm: 90,
                ),
                UIHelper.verticalSpaceMedium(),
                // Text("Debug Stuff Counter: $_longPressCounter")
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TextHighlight extends StatefulWidget {
  final String text;
  final int wpm;

  TextHighlight({Key key, this.text = "", this.wpm = 60}) : super(key: key);

  _TextHighlightState createState() => _TextHighlightState();
}

class _TextHighlightState extends State<TextHighlight>
    with SingleTickerProviderStateMixin {
  Animation<int> _animation;
  AnimationController _controller;
  Duration _duration;
  int _wpm = 150;
  int _longPressCounter = 0;
  bool _counterPressed = false;
  bool _loopActive = false;
  int _animationCounter = 0;

  // void _increaseCounterWhilePressed() async {
  //   // make sure that only one loop is active
  //   if (_loopActive) return;

  //   _loopActive = true;

  //   while (_counterPressed) {
  //     // do your thing
  //     setState(() {
  //       _longPressCounter++;
  //     });

  //     // wait a bit
  //     if (_highlightIndex == _fullTextLength - 1) {
  //       setState(() {
  //         _repeatCounter++;
  //       });
  //       break;
  //     }
  //     await Future.delayed(Duration(milliseconds: _textHighlightDelay));
  //   }

  //   _loopActive = false;
  // }

  @override
  void initState() {
    var durationInMS = ((widget.text.split(" ").length / _wpm) * 60000).toInt();
    _duration = Duration(milliseconds: durationInMS);
    _controller = AnimationController(vsync: this, duration: _duration);

    // animation = Tween<double>(begin: -100.0, end: 100.0).animate(_controller);
    var tween = StepTween(begin: 0, end: widget.text.length);
    _animation = tween
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _animation.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationCounter++;
        // _controller.reset();
      }
    });
    // _controller.repeat();
    // animation.addStatusListener((status) => print(status));

    super.initState();
  }

  buildRepetitionButton() {
    return GestureDetector(
        onLongPressStart: (details) {
          _counterPressed = true;
          // _controller.forward();
          // if (_controller.status == AnimationStatus.forward) {
          //   _controller.forward();
          if (_controller.status == AnimationStatus.completed) {
            _controller.reset();
          }
          _controller.forward();
          // _increaseCounterWhilePressed();
        },
        onLongPressEnd: (details) {
          _controller.stop();
          _counterPressed = false;
        },
        child: SizedBox(
            width: double.infinity,
            height: 80,
            child: RaisedButton(
              onPressed: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Gedrückt halten und Text lesen",
                      style: TextStyle(fontSize: 20)),
                  Text("Bisher $_animationCounter-mal gelesen",
                      style: TextStyle(fontSize: 20)),
                ],
              ),
            )));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildRepetitionButton(),
        UIHelper.verticalSpaceMedium(),
        SizedBox(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (BuildContext context, Widget child) {
              var partialText = widget.text.substring(0, _animation.value);
              return Stack(
                children: <Widget>[
                  Text(widget.text,
                      style:
                          TextStyle(fontSize: 30.0, color: Colors.grey[400])),
                  Text(partialText, style: TextStyle(fontSize: 30.0)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
