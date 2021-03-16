import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

typedef void IntervalScaleCallback(String val);

class IntervalScale extends StatefulWidget {
  @override
  _IntervalScaleState createState() => _IntervalScaleState();

  final String title;
  final Map<String, String> labels;
  final String id;
  final IntervalScaleCallback callback;
  final int groupValue;

  IntervalScale(
      {Key key,
      this.title = "",
      @required this.labels,
      this.groupValue = 0,
      this.id = "",
      @required this.callback})
      : super(key: key);
}

class _IntervalScaleState extends State<IntervalScale> {
  int _groupValue = 0;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.groupValue;
  }

  _onChanged(int value) {
    setState(() {
      _groupValue = value;
    });
    if (widget.callback != null) {
      widget.callback(value.toString());
    }
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
            onChanged: _onChanged,
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
        widget.callback(value.toString());
      },
    );
  }

  String getLabel(String key) {
    if (widget.labels != null) {
      if (widget.labels.containsKey(key)) {
        return widget.labels[key];
      }
    }
    return "MISSING LABEL";
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      MarkdownBody(
        data: "### " + widget.title,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          for (var i = 1; i <= widget.labels.keys.length; i++)
            buildItem(i, getLabel(i.toString())),
        ],
      )
    ]);
  }
}
