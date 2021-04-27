import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:prompt/shared/enums.dart';

class HelpScreen extends StatelessWidget {
  final InternalisationCondition helpType;
  const HelpScreen(
    this.helpType, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: getHelpWidget(helpType),
    );
  }

  Widget getHelpWidget(InternalisationCondition helpType) {
    switch (helpType) {
      case InternalisationCondition.waiting:
        return getWaitingHelpWidget();
        break;
      case InternalisationCondition.scrambleWithHint:
        return getScrambleHelpWidget();
        break;
      case InternalisationCondition.emoji:
        return getEmojiHelpWidget();
        break;
    }
    return Text("");
  }

  Widget getEmojiHelpWidget() {
    return ListView(
      children: [
        MarkdownBody(
          data: "## Deine nächste Aufgabe",
        ),
        MarkdownBody(
            data:
                """Als nächstes sollst du Emojis benutzen, die so gut wie möglich deinen Plan darstellen. 
                Trage in das linke Feld Emojis ein, die zum 'Wenn'-Teil deines Planes passen, 
                und in das rechte Feld Emojis, die zum 'Dann'-Teil deines Planes passen."""),
        MarkdownBody(
            data:
                """Die Emojis sollen dir helfen, dir den **ganzen** Satz zu merken. Hier siehst du einen Beispielsatz mit möglichen Emojis:"""),
        getHelpImage("assets/information/emoji_complete.png"),
        MarkdownBody(
          data:
              """ Es gibt viele verschiedene Möglichkeiten beim Auswählen der Emojis. Wähle einfach die Emojis, die dir helfen, dir den Satz zu merken.""",
        )
      ],
    );
  }

  static Widget getWaitingHelpWidget() {
    return ListView(
      children: [
        MarkdownBody(
          data: "## Deine nächste Aufgabe",
        ),
        MarkdownBody(
            data:
                """Als nächstes sollst du in Ruhe und mit viel Sorgfalt den Plan auf der nächsten Seite dreimal lesen
                und ihn dir dabei ganz deutlich vorstellen, damit du ihn dir gut merken kannst"""),
      ],
    );
  }

  static Widget getRecallHelpWidget() {
    return ListView(
      children: [
        MarkdownBody(
            data:
                """Hier sollst du dich so gut wie es geht an deinen Plan von heute erinnern. 
                Es ist gar nicht schlimm, wenn es nicht genau ist, aber versuche trotzdem, 
                dich so gut es geht zu erinnern. Falls du dir deinen Plan mit Emojis eingeprägt hast, 
                sollst du dir trotzdem den richtigen Plan merken, nicht die Emoji-Darstellung."""),
      ],
    );
  }

  static Widget getScrambleHelpWidget() {
    return ListView(
      children: [
        MarkdownBody(
          data: "## Deine nächste Aufgabe",
        ),
        MarkdownBody(
            data:
                """Auf der nächsten Seite sollst du dir den Satz erstmal durchlesen und einprägen. Dann verschwindet der Satz und du sollst ihn aus einzelnen Wörtern wieder zusammenbauen.  
                Am Anfang ist der Plan noch wild durcheinander gewürfelt, zum Beispiel:"""),
        getHelpImage("assets/information/puzzle_bare.png"),
        MarkdownBody(
            data:
                """Wenn du auf ein Wort drückst, dann wird es dem Satz hinzugefügt. 
          Mit der Taste unter dem Satz kannst du Wörter wieder entfernen. Am Ende soll der Plan dann aus einzelnen Wörtern wieder richtig zusammengebaut sein:"""),
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
