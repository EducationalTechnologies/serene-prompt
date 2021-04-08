import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:serene/shared/ui_helpers.dart';

class InitialRewardScreenFirst extends StatelessWidget {
  const InitialRewardScreenFirst({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          MarkdownBody(data: "### Du bekommst 4💎."),
          UIHelper.verticalSpaceMedium(),
          MarkdownBody(
              data:
                  "### Du hast dir gerade deine erste Belohnung in der App verdient"),
          UIHelper.verticalSpaceMedium(),
          MarkdownBody(
              data:
                  "### Jeder 💎 den du sammelst ist wie ein Losticket, und wenn du die Studie bis zum Ende mitmachst, bekommst du für mehr 💎 bessere Preise."),
        ],
      ),
    );
  }
}
