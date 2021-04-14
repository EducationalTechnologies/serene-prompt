import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:prompt/shared/ui_helpers.dart';

class InitialRewardScreenSecond extends StatelessWidget {
  const InitialRewardScreenSecond({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          MarkdownBody(data: "# Du bekommst 💎💎💎💎."),
          UIHelper.verticalSpaceMedium(),
          MarkdownBody(
              data:
                  "### Denk daran: Jeder 💎, den du sammelst, ist ein Losticket für einen tollen Preis!"),
        ],
      ),
    );
  }
}
