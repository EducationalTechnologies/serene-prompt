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
          MarkdownBody(data: "## Danke für deine Mitarbeit bis hierhin!"),
          MarkdownBody(data: "## Du hast dir damit deine ersten 2💎 verdient"),
          UIHelper.verticalSpaceMedium(),
          Text(
              "Jeder💎 den du sammelst ist wie ein Losticket, und wenn du die Studie bis zum Ende mitmachst, bekommst du für mehr 💎 bessere Preise."),
        ],
      ),
    );
  }
}
