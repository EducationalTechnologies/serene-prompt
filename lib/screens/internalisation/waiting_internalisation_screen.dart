import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/internalisation_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';

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
  bool _done = false;

  int _timerDurationSeconds = 15;

  bool _timerStarted = false;

  @override
  void initState() {
    super.initState();
    initTimer();
  }

  void initTimer() {
    controller = AnimationController(
        duration: Duration(seconds: _timerDurationSeconds), vsync: this);
    animation = Tween<double>(begin: 0, end: pi / 2).animate(controller);
    animation.addListener(() {
      setState(() {});
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _done = true;
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buildSubmitButton() {
    final vm = Provider.of<InternalisationViewModel>(context, listen: false);
    return SizedBox(
        width: double.infinity,
        height: 60,
        child: RaisedButton(
          onPressed: () async {
            await vm.submit(InternalisationCondition.waiting);
            Navigator.pushNamed(context, RouteNames.NO_TASKS);
          },
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0)),
          child: Text("Abschicken", style: TextStyle(fontSize: 20)),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<InternalisationViewModel>(context, listen: false);

    if (_timerStarted) {
      return _buildPreTimerScreen();
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
            UIHelper.verticalSpaceMedium(),
            if (_done) _buildSubmitButton()
          ],
        ),
      );
    }
  }

  _buildPreTimerScreen() {
    return Container(
        margin: UIHelper.getContainerMargin(),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/illustrations/undraw_in_no_time_6igu.png"),
          fit: BoxFit.scaleDown,
        )),
        child: Align(
            child: Column(
              children: [
                Text(
                    "Sobald du anfängst, hast du $_timerDurationSeconds Sekunden Zeit, um dir deinen Wenn-Dann-Plan einzuprägen",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4),
                FullWidthButton(onPressed: () {
                  setState(() {
                    _timerStarted = true;
                  });
                  initTimer();
                })
              ],
            ),
            alignment: Alignment(0.0, 0.6)));
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
              strokeWidth: 19,
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
