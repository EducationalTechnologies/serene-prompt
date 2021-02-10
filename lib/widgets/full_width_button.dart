import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class FullWidthButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;
  final double height;

  FullWidthButton(
      {@required this.onPressed, this.text = "Abschicken", this.height = 60});

  // const FullWidthButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: this.height,
        child: RaisedButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15.0)),
          child: Text(this.text, style: TextStyle(fontSize: 20)),
        ));
  }
}
