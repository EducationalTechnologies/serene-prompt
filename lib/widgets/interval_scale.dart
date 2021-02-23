import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

typedef void IntervalScaleCallback(String val);

class IntervalScale extends StatefulWidget {
  @override
  _IntervalScaleState createState() => _IntervalScaleState();

  final String title;
  final int itemCount;
  final Map<int, String> labels;
  final String id;
  final IntervalScaleCallback callback;
  final int groupValue;

  IntervalScale(
      {Key key,
      this.title,
      this.itemCount = 5,
      this.labels,
      this.groupValue,
      this.id,
      this.callback})
      : super(key: key);
}

class _IntervalScaleState extends State<IntervalScale> {
  int _groupValue;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.groupValue;
  }

  buildItem(int value, String text) {
    if (text == null) {
      text = value.toString();
    }
    return InkWell(
      child: Row(
        children: <Widget>[
          Radio(
            groupValue: _groupValue,
            value: value,
            onChanged: (val) {
              setState(() {
                _groupValue = val;
              });
              widget.callback(val.toString());
            },
          ),
          MarkdownBody(
            data: text,
          )
        ],
      ),
      onTap: () {
        setState(() {
          _groupValue = value;
        });
      },
    );
  }

  getLabel(int index) {
    if (widget.labels != null) {
      if (widget.labels.containsKey(index)) {
        return widget.labels[index];
      }
    }
    return index.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      MarkdownBody(
        data: "### " + widget.title,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          for (var i = 1; i <= widget.itemCount; i++) buildItem(i, getLabel(i)),
        ],
      )
    ]);
  }
}
