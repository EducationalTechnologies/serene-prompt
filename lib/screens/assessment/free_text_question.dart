import 'package:flutter/material.dart';
import 'package:serene/shared/ui_helpers.dart';

typedef TextChangedCallback(String text);

class FreeTextQuestion extends StatelessWidget {
  final String description;
  final TextChangedCallback textChanged;
  const FreeTextQuestion(this.description, {Key key, this.textChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          this.description,
          style: Theme.of(context).textTheme.headline6,
        ),
        UIHelper.verticalSpaceMedium(),
        TextField(
          onChanged: this.textChanged,
          autofocus: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(), focusColor: Colors.white),
        ),
      ],
    ));
  }
}
