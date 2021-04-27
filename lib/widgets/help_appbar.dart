import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:prompt/locator.dart';
import 'package:prompt/services/logging_service.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/shared/ui_helpers.dart';

class HelpAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final HelpType helpType;
  final bool showHelpImmediately;

  const HelpAppBar(this.helpType,
      {Key key, this.title = "", this.showHelpImmediately = false})
      : super(key: key);

  @override
  _HelpAppBarState createState() => _HelpAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class _HelpAppBarState extends State<HelpAppBar> {
  @override
  void initState() {
    super.initState();

    if (widget.showHelpImmediately) {
      Future.delayed(Duration(milliseconds: 50), () {
        showHelpDialog();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  AppBar build(BuildContext context) {
    // if (widget.showHelpImmediately) {
    //   showHelpDialog();
    // }
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        TextButton(
            onPressed: () {
              locator<LoggingService>().logEvent("HelpClick",
                  data: {"HelpType": widget.helpType.toString()});
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
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text("Hilfe"),
        content: Container(
            width: double.maxFinite, child: getHelpWidget(widget.helpType)),
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

  Widget getHelpWidget(HelpType helpType) {
    switch (helpType) {
      case HelpType.general:
        return Text(
            "Wenn du nicht verstehst was du hier tun sollst, melde dich telefonisch bei **Jasmin Breitwieser: 069 24708 375**");
      case HelpType.emojiInternalisation:
        return getEmojiHelpWidget();
        break;
      case HelpType.waitingInternalisation:
        return getWaitingHelpWidget();
        break;
      case HelpType.scrambleInternalisation:
        return getScrambleHelpWidget();
        break;
      case HelpType.recall:
        return getRecallHelpWidget();
        break;
    }
    return Text("");
  }

  Widget getEmojiHelpWidget() {
    return ListView(
      children: [
        MarkdownBody(
            data:
                """Hier sollst du Emojis benutzen, die so gut wie möglich deinen Plan darstellen. 
                Trage in das linke Feld Emojis ein, die zum 'Wenn'-Teil deines Planes passen, 
                und in das rechte Feld Emojis, die zum 'Dann'-Teil deines Planes passen."""),
        MarkdownBody(
            data:
                """Die Emojis sollen dir helfen, dir den **ganzen** Satz zu merken. Hier siehst du einen Beispielsatz mit möglichen Emojis:"""),
        getHelpImage("assets/information/emoji_complete.png"),
        MarkdownBody(
          data:
              """Es gibt viele verschiedene Möglichkeiten beim Auswählen der Emojis. Wähle einfach die Emojis, die dir helfen, dir den Satz zu merken.""",
        )
      ],
    );
  }

  static Widget getWaitingHelpWidget() {
    return ListView(
      children: [
        MarkdownBody(
            data:
                """Hier sollst du in Ruhe und mit viel Sorgfalt den Plan auf der nächsten Seite dreimal lesen
                und ihn dir dabei ganz deutlich vorstellen, damit du ihn dir gut merken kannst"""),
      ],
    );
  }

  static Widget getRecallHelpWidget() {
    return ListView(
      children: [
        MarkdownBody(
            data:
                """Hier sollst du dich so gut du kannst an deinen Plan von heute erinnern. Es ist nicht schlimm, wenn du dir nicht mehr ganz sicher bist. Versuche dich trotzdem so gut es geht an den Satz zu erinnern. 
                Wenn du dich nur noch an einzelne Wörter des Satzes erinnern kannst, dann gib diese trotzdem in die Felder ein.
                Bitte gib hier nur Wörter ein."""),
      ],
    );
  }

  static Widget getScrambleHelpWidget() {
    return ListView(
      children: [
        MarkdownBody(
            data:
                """Hier sollst du aus einzelnen Wörtern den kompletten Plan wieder zusammenbauen. 
                Am Anfang ist der Plan noch wild durcheinander gewürfelt, zum Beispiel:"""),
        getHelpImage("assets/information/puzzle_bare.png"),
        MarkdownBody(
            data:
                """Wenn du auf ein Wort drückst, dann wird es dem Satz hinzugefügt. 
          Mit der Taste unter dem Satz, kannst du Wörter wieder entfernen. Am Ende soll der Plan dann aus einzelnen Wörtern wieder richtig zusammengebaut sein:"""),
        getHelpImage("assets/information/puzzle_almostComplete.png"),
        MarkdownBody(
            data:
                """**Tipp**: Wir achten bei den Sätzen auch auf Satzstellung. Wenn dein zusammengebauter Satz noch nicht richtig ist, dann überleg noch einmal wie die Satzstellung war.""")
      ],
    );
  }

  static Widget getHelpImage(String path) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.all(15.0),
      child: Image(image: AssetImage(path)),
    );
  }
}
