import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class FullWidthButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;

  FullWidthButton({@required this.onPressed, this.text = "Abschicken"});

  // const FullWidthButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 60,
        child: RaisedButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15.0)),
          child: Text(this.text, style: TextStyle(fontSize: 20)),
        ));
  }
}
