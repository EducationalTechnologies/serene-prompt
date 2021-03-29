import 'package:flutter/material.dart';

class CountDown extends StatefulWidget {
  final int durationSeconds;
  final VoidCallback onFinished;
  CountDown(this.durationSeconds, {key, this.onFinished}) : super(key: key);

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<int> animation;

  String text = "Gleich geht es los:";
  int countDown = 5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.durationSeconds));
    _controller.forward();

    animation =
        StepTween(begin: widget.durationSeconds, end: 0).animate(_controller);

    animation.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // custom code here
        if (widget.onFinished != null) {
          widget.onFinished();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          animation.value.toString(),
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }
}
