import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:implementation_intentions/shared/text_styles.dart';

class IntervalScale extends StatefulWidget {
  @override
  _IntervalScaleState createState() => _IntervalScaleState();

  final String title;

  const IntervalScale({Key key, this.title}) : super(key: key);
}

class _IntervalScaleState extends State<IntervalScale> {
  int _groupValue;

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
          Radio(
            groupValue: _groupValue,
            value: 1,
            onChanged: (val) {
              setState(() {
                _groupValue = val;
              });
            },
          ),
          Radio(
            groupValue: _groupValue,
            value: 2,
            onChanged: (val) {
              setState(() {
                _groupValue = val;
              });
            },
          ),
          Column(
            children: <Widget>[
              Radio(
                groupValue: _groupValue,
                value: 3,
                onChanged: (val) {
                  setState(() {
                    _groupValue = val;
                  });
                },
              ),
              Text("Super",)
            ],
          ),
          Radio(
            groupValue: _groupValue,
            value: 4,
            onChanged: (val) {
              setState(() {
                _groupValue = val;
              });
            },
          ),
          Radio(
            groupValue: _groupValue,
            value: 5,
            onChanged: (val) {
              setState(() {
                _groupValue = val;
              });
            },
          ),
          Radio(
            groupValue: _groupValue,
            value: 6,
            onChanged: (val) {
              setState(() {
                _groupValue = val;
              });
            },
          ),
          Radio(
            groupValue: _groupValue,
            value: 7,
            onChanged: (val) {
              setState(() {
                _groupValue = val;
              });
            },
          )
        ],
      )
    ]);
  }
}
