import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/locator.dart';
import 'package:serene/services/settings_service.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';

class LongPressInternalisation extends StatefulWidget {
  @override
  _LongPressInternalisationState createState() =>
      _LongPressInternalisationState();
}

class _LongPressInternalisationState extends State<LongPressInternalisation> {
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

  @override
  Widget build(BuildContext context) {
    final intention = Provider.of<InternalisationViewModel>(context);

    return Column(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              UIHelper.verticalSpaceMedium(),
              UIHelper.verticalSpaceMedium(),
              TextHighlight(
                  text: intention.implementationIntention,
                  wpm: locator.get<SettingsService>().getWordsPerMinute()),
              UIHelper.verticalSpaceMedium(),
              // Text("Debug Stuff Counter: $_longPressCounter")
            ],
          ),
        ),
      ],
    );
  }
}

class TextHighlight extends StatefulWidget {
  final String text;
  final double wpm;

  TextHighlight({Key key, this.text = "", this.wpm = 180}) : super(key: key);

  _TextHighlightState createState() => _TextHighlightState();
}

class _TextHighlightState extends State<TextHighlight>
    with SingleTickerProviderStateMixin {
  Animation<int> _animation;
  AnimationController _controller;
  Duration _duration;

  _onIterationCompleted() async {
    await Future.delayed(Duration(seconds: 1)).then((res) {
      Navigator.pushNamed(context, RouteNames.AMBULATORY_ASSESSMENT_PRE_TEST);
    });
  }

  @override
  void initState() {
    var durationInMS =
        ((widget.text.split(" ").length / widget.wpm * 60000).toInt());
    _duration = Duration(milliseconds: durationInMS);
    _controller = AnimationController(vsync: this, duration: _duration);

    // animation = Tween<double>(begin: -100.0, end: 100.0).animate(_controller);
    var tween = StepTween(begin: 0, end: widget.text.length);
    _animation = tween.animate(_controller);

    _animation.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onIterationCompleted();
      }
    });

    super.initState();
  }

  buildRepetitionButton() {
    return GestureDetector(
        onLongPressStart: (details) {
          if (_controller.status == AnimationStatus.completed) {
            _controller.reset();
          }
          _controller.forward();
        },
        onLongPressEnd: (details) {
          _controller.stop();
        },
        child: SizedBox(
            width: double.infinity,
            height: 80,
            child: ElevatedButton(
              onPressed: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Gedrückt halten und Text lesen",
                      style: TextStyle(fontSize: 20)),
                  // Text("Bisher $_animationCounter-mal gelesen",
                  //     style: TextStyle(fontSize: 20)),
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
        UIHelper.verticalSpaceLarge(),
        buildRepetitionButton(),
      ],
    );
  }
}
