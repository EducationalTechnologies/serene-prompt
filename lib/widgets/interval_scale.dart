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
      this.groupValue = -1,
      this.id = "",
      @required this.callback})
      : super(key: key);
}

class _IntervalScaleState extends State<IntervalScale> {
  int _groupValue = -1;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.groupValue;
  }

  _onChanged(int groupValue, String selectedValue) {
    setState(() {
      _groupValue = groupValue;
    });
    if (widget.callback != null) {
      widget.callback(selectedValue);
    }
  }

  buildStaticItem(int groupValue, String text) {
    if (text == null) {
      text = groupValue.toString();
    }
    return InkWell(
      child: Row(
        children: <Widget>[
          Radio(
            groupValue: _groupValue,
            value: groupValue,
            onChanged: (value) {
              // FocusScope.of(context).unfocus();
              _onChanged(value, groupValue.toString());
            },
          ),
          Expanded(
            child: MarkdownBody(
              data: text,
            ),
          )
        ],
      ),
      onTap: () {
        _onChanged(groupValue, groupValue.toString());
      },
    );
  }

  buildTextInputItem(int groupValue, String text) {
    if (text == null) {
      text = groupValue.toString();
    }
    return Column(
      children: [
        InkWell(
          child: Row(
            children: <Widget>[
              Radio(
                groupValue: _groupValue,
                value: groupValue,
                onChanged: (val) {
                  _onChanged(val, text);
                },
              ),
              MarkdownBody(
                data: text,
              )
            ],
          ),
          onTap: () {
            // FocusScope.of(context).nextFocus();
            FocusScope.of(context).nextFocus();
            _onChanged(groupValue, text);
          },
        ),
        Container(
          margin: EdgeInsets.only(left: 15.0),
          child: TextField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            onTap: () {
              setState(() {
                _groupValue = groupValue;
              });
            },
            onChanged: (text) {
              _onChanged(groupValue, text);
            },
          ),
        )
      ],
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
    List<Widget> items = [];

    int groupValue = 1;
    for (var key in widget.labels.keys) {
      if (key.contains("TEXTINPUT")) {
        items.add(buildTextInputItem(groupValue, widget.labels[key]));
      } else {
        items.add(buildStaticItem(groupValue, widget.labels[key]));
      }
      groupValue += 1;
    }

    return Column(children: <Widget>[
      MarkdownBody(
        data: "### " + widget.title,
      ),
      Column(mainAxisAlignment: MainAxisAlignment.start, children: items)
    ]);
  }
}
