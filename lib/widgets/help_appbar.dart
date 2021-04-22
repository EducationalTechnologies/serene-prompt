import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:prompt/shared/ui_helpers.dart';

enum HelpType {
  general,
  emojiInternalisation,
  waitingInternalisation,
  scrambleInternalisation,
  recall
}

class HelpAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final HelpType helpType;

  const HelpAppBar(this.helpType, {Key key, this.title = ""}) : super(key: key);

  @override
  _HelpAppBarState createState() => _HelpAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class _HelpAppBarState extends State<HelpAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        TextButton(
            onPressed: () {
              showHelpDialog();
            },
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              UIHelper.horizontalSpaceMedium(),
              Text("Hilfe"),
              Icon(Icons.help),
              UIHelper.horizontalSpaceMedium(),
            ])),
      ],
      title: Text(""),
      textTheme:
          TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 22)),
      centerTitle: true,
    );
  }

  showHelpDialog() async {
    String helpText = getHelpText(widget.helpType);

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text("Hilfe"),
        content: new Column(
          children: [
            MarkdownBody(data: helpText),
          ],
        ),
        actions: <Widget>[
          new ElevatedButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  String getHelpText(HelpType helpType) {
    switch (helpType) {
      case HelpType.general:
        return "Wenn du nicht verstehst was du hier tun sollst, melde dich telefonisch bei **Jasmin Breitwieser: 069 24708 375**";
      case HelpType.emojiInternalisation:
        return "Hier musst du Emojis benutzen, die so gut wie möglich deinen Plan repräsentieren. Trage in das linke Feld Emojis ein, die den 'Wenn'-Teil deines Planes gut repräsentieren, und in das rechte Feld Emojis, die den 'Dann'-Teil deines Planes gut repräsentieren.";
        break;
      case HelpType.waitingInternalisation:
        return "Hier musst du in Ruhe und mit viel Sorgfalt den Plan drei-mal lesen und ihn dir dabei ganz deutlich vorstellen.";
        break;
      case HelpType.scrambleInternalisation:
        return "Hier musst du aus einzelnen Wörtern den kompletten Plan zusammenbauen. Wenn du auf ein Wort drückst, dann wird es dem Satz hinzugefügt. Wenn du es wieder entfernen möchtest, drücke nochmal auf das Wort drauf.";
        break;
      case HelpType.recall:
        return "Hier musst du dich so gut wie es geht an deinen Plan von heute erinnern. Es ist gar nicht schlimm, wenn es nicht genau ist, aber versuche trotzdem, dich so gut es geht zu erinnern. Falls du dir deinen Plan mit Emojis eingeprägt hast, sollst du dir trotzdem den richtigen Plan merken, nicht die Emoji-Darstellung.";
        break;
    }
    return "";
  }
}
