import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

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
      children: [
        Text(
          this.description,
          style: Theme.of(context).textTheme.headline6,
        ),
        TextField(
          onChanged: this.textChanged,
          autofocus: true,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    ));
  }
}
