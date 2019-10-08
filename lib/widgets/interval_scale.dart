import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:serene/shared/text_styles.dart';

class IntervalScale extends StatefulWidget {
  @override
  _IntervalScaleState createState() => _IntervalScaleState();

  final String title;
  final int itemCount;

  const IntervalScale({Key key, this.title, this.itemCount = 5})
      : super(key: key);
}

class _IntervalScaleState extends State<IntervalScale> {
  int _groupValue;

  buildItem(int value) {
    return Column(
      children: <Widget>[
        Radio(
          groupValue: _groupValue,
          value: value,
          onChanged: (val) {
            setState(() {
              _groupValue = val;
            });
          },
        ),
        Text(
          "Super",
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        widget.title,
        style: subHeaderStyle,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          for (var i = 1; i <= widget.itemCount; i++) buildItem(i),
        ],
      )
    ]);
  }
}
