import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';

class WaitingInternalisationScreen extends StatefulWidget {
  @override
  _WaitingInternalisationScreenState createState() =>
      _WaitingInternalisationScreenState();
}

class _WaitingInternalisationScreenState
    extends State<WaitingInternalisationScreen>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  TextEditingController _textController;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _textController = new TextEditingController(text: "");

    controller =
        AnimationController(duration: Duration(seconds: 15), vsync: this);
    animation = Tween<double>(begin: 0, end: pi / 2).animate(controller);
    animation.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildTextEntry() {
    final vm = Provider.of<InternalisationViewModel>(context, listen: false);
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10, bottom: 30, top: 20),
      decoration: BoxDecoration(
          // color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.text,
              maxLines: null,
              textInputAction: TextInputAction.done,
              onChanged: (text) {
                setState(() {});
                print("ON CHANGED");
              },
              onSubmitted: (text) {
                setState(() {
                  _done = true;
                });
                if (text.toLowerCase() ==
                    vm.implementationIntention.toLowerCase()) {
                  print("MATCH");
                } else {
                  print("NO MATCH");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildSubmitButton() {
    return SizedBox(
        width: double.infinity,
        height: 60,
        child: RaisedButton(
          onPressed: () => {
            Navigator.pushNamed(
                context, RouteNames.AMBULATORY_ASSESSMENT_PRE_TEST)
          },
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          child: Text("Abschicken", style: TextStyle(fontSize: 20)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<InternalisationViewModel>(context, listen: false);
    return Container(
      child: ListView(
        children: <Widget>[
          UIHelper.verticalSpaceMedium(),
          UIHelper.verticalSpaceMedium(),
          Text(vm.implementationIntention,
              style: TextStyle(fontSize: 30.0, color: Colors.grey[900])),
          UIHelper.verticalSpaceMedium(),
          Center(
              child: CircleProgressBar(
                  foregroundColor: Theme.of(context).primaryColor,
                  animationDuration: Duration(seconds: 5),
                  value: animation.value)),
          UIHelper.verticalSpaceMedium(),
          buildTextEntry(),
          UIHelper.verticalSpaceMedium(),
          if (_done) _buildSubmitButton()
        ],
      ),
    );
  }
}

/// Draws a circular animated progress bar.
class CircleProgressBar extends StatefulWidget {
  final Duration animationDuration;
  final Color backgroundColor;
  final Color foregroundColor;
  final double value;

  const CircleProgressBar({
    Key key,
    this.animationDuration,
    this.backgroundColor,
    @required this.foregroundColor,
    @required this.value,
  }) : super(key: key);

  @override
  CircleProgressBarState createState() {
    return CircleProgressBarState();
  }
}

class CircleProgressBarState extends State<CircleProgressBar>
    with SingleTickerProviderStateMixin {
  // Used in tweens where a backgroundColor isn't given.
  static const TRANSPARENT = Color(0x00000000);
  AnimationController _controller;

  Animation<double> curve;
  Tween<double> valueTween;
  Tween<Color> backgroundColorTween;
  Tween<Color> foregroundColorTween;

  @override
  void initState() {
    super.initState();

    this._controller = AnimationController(
      duration: this.widget.animationDuration ?? const Duration(seconds: 1),
      vsync: this,
    );

    this.curve = CurvedAnimation(
      parent: this._controller,
      curve: Curves.linear,
    );

    // Build the initial required tweens.
    this.valueTween = Tween<double>(
      begin: 0,
      end: this.widget.value,
    );

    this._controller.forward();
  }

  @override
  void didUpdateWidget(CircleProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget.value != oldWidget.value) {
      // Try to start with the previous tween's end value. This ensures that we
      // have a smooth transition from where the previous animation reached.
      double beginValue =
          this.valueTween?.evaluate(this.curve) ?? oldWidget?.value ?? 0;

      // Update the value tween.
      this.valueTween = Tween<double>(
        begin: beginValue,
        end: this.widget.value ?? 1,
      );

      // Clear cached color tweens when the color hasn't changed.
      if (oldWidget?.backgroundColor != this.widget.backgroundColor) {
        this.backgroundColorTween = ColorTween(
          begin: oldWidget?.backgroundColor ?? TRANSPARENT,
          end: this.widget.backgroundColor ?? TRANSPARENT,
        );
      } else {
        this.backgroundColorTween = null;
      }

      if (oldWidget.foregroundColor != this.widget.foregroundColor) {
        this.foregroundColorTween = ColorTween(
          begin: oldWidget?.foregroundColor,
          end: this.widget.foregroundColor,
        );
      } else {
        this.foregroundColorTween = null;
      }

      this._controller
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: this.curve,
        child: Container(),
        builder: (context, child) {
          final backgroundColor =
              this.backgroundColorTween?.evaluate(this.curve) ??
                  this.widget.backgroundColor;
          final foregroundColor =
              this.foregroundColorTween?.evaluate(this.curve) ??
                  this.widget.foregroundColor;

          return CustomPaint(
            child: child,
            foregroundPainter: CircleProgressBarPainter(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              percentage: this.valueTween.evaluate(this.curve),
            ),
          );
        },
      ),
    );
  }
}

// Draws the progress bar.
class CircleProgressBarPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;

  CircleProgressBarPainter({
    this.backgroundColor,
    @required this.foregroundColor,
    @required this.percentage,
    double strokeWidth,
  }) : this.strokeWidth = strokeWidth ?? 6;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final Size constrainedSize =
        size - Offset(this.strokeWidth, this.strokeWidth);
    final shortestSide = min(constrainedSize.width, constrainedSize.height);
    final foregroundPaint = Paint()
      ..color = this.foregroundColor
      ..strokeWidth = this.strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final radius = (shortestSide / 2);

    // Start at the top. 0 radians represents the right edge
    final double startAngle = -(2 * pi * 0.25);
    final double sweepAngle = (2 * pi * (this.percentage ?? 0));

    // Don't draw the background if we don't have a background color
    if (this.backgroundColor != null) {
      final backgroundPaint = Paint()
        ..color = this.backgroundColor
        ..strokeWidth = this.strokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, backgroundPaint);
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final oldPainter = (oldDelegate as CircleProgressBarPainter);
    return oldPainter.percentage != this.percentage ||
        oldPainter.backgroundColor != this.backgroundColor ||
        oldPainter.foregroundColor != this.foregroundColor ||
        oldPainter.strokeWidth != this.strokeWidth;
  }
}
