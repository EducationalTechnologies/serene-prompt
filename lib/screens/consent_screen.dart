import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:serene/state/consent_state.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';

// TODO: Use markdown
class ConsentScreen extends StatelessWidget {
  bool consented = false;

  List<String> _textIntroduction = [
    "Einverständniserklärung für das Sammeln und die Verarbeitung von Daten im Rahmen des 'Serene' Forschungsprojektes der Educational Technologies Gruppe am DIPF | Leibniz-Institut für Bildungsforschung und Bildungsinformation"
  ];

  String _subheaderPurposes = "Zweck der Datensammlung";

  List<String> _textPurposes = [
    "Das Sammeln von Daten im Rahmen des Serene Projektes verfolgt die folgenden Ziele: ",
    "Den individuellen Lernfortschritt zu untersuchen und zu unterstützen. Wir geben Ihnen die Möglichkeit, Ihr persönliches Lernverhalten mit Ihren Zielen zu vergleichen und somit vielleicht auch Ihren Lernfortschritt zu steigern.",
    "Um die Auswirkungen der Verwendung von Technologien auf Lernumgebungen zu untersuchen. Wir möchten herausfinden, welche Vor- und Nachteile Technologien und deren Verwendung mit sich bringt. Wir wollen diese Erkenntnisse nutzen um die angebotenen Technologien stetig zu vebressern"
  ];

  String _subheaderWhichData = "Welche Daten werden gesammelt?";
  String _textParagraph5 =
      "Serene ist eine Applikation mit der Lernziele erstellt und verfolgt werden können. Sie können die Anwendung unter Nutzung eines selbstgewählten Pesudonyms nutzen, sodass ausschließlich **pseudonymisierte** Daten anfallen. Von Ihrer Nutzung der Serene-Applikation verwenden : ";
  List<String> _dataCollectionAggregated = [
    "* Text der Lernziele",
    "* Datum der Lernziele",
    "* Zeitpläne für die Lernziele",
    "* Der angegebene Fortschritt beim Erreichen der Lernziele"
  ];
  String _textParagraph6 =
      "In der Serene Applikation erheben und verwerten wir die folgenden Daten:";

  String _subheaderWhatHappensWithData =
      "Was passiert mit den Daten die über mich gesammelt werden?";
  List<String> _textWhatHappensWithData = [
    "Die Daten werden während des Semesters gesammelt und anschließend vollständig anonym für die wissenschaftliche Forschung verwendet. Insbesondere erhält das Lehrpersonal keinen Zugriff auf die Daten",
    "Für die Analyse der Daten werden die Daten in aggregierter Form gehandhabt und die Forscher/innen werden diese statistisch untersuchen. Dabei wird untersucht wie die gesetzten Lernziele und Lernzeiten in Verbindung zu einzelnen Funktionalitäten der Applikation stehen.",
    ""
  ];

  String _subheaderWhichRights = "Welche Rechte habe ich?";
  String _textRights1 =
      "Im Bezug auf pSie haben jederzeit die Möglichkeit folgende Rechte geltend zu machen: ";
  List<String> _rights = [""];

  buildSubheader(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20),
    );
  }

  buildConsentCardWhichData(
      String title, List<String> paragraphs, List<String> dataCollected) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(title),
            ),
            for (var text in paragraphs) MarkdownBody(data: text),
            for (var text in dataCollected) MarkdownBody(data: text)
          ],
        ),
      ),
    );
  }

  buildConsentCard(List<String> paragraphs) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          children: <Widget>[for (var text in paragraphs) MarkdownBody(data: text)],
        ),
      ),
    );
  }

  buildSubmitButton() {
    return RaisedButton(
      onPressed: () {},
      child: Text("Abschicken"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final consentState = Provider.of<ConsentState>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: (ListView(
          children: <Widget>[
            buildSubheader("Informierte Einwilligung"),
            buildConsentCard(_textIntroduction),
            UIHelper.verticalSpaceSmall(),
            buildConsentCardWhichData(_subheaderPurposes, _textPurposes, []),
            UIHelper.verticalSpaceSmall(),
            buildConsentCardWhichData(_subheaderWhichData,
                [_textParagraph5, _textParagraph6], _dataCollectionAggregated),
            UIHelper.verticalSpaceSmall(),
            buildConsentCardWhichData(
                _subheaderWhatHappensWithData, _textWhatHappensWithData, []),
            // UIHelper.verticalSpaceSmall(),
            // buildSubheader(_subheaderWhichRights),
            // buildConsentCard([_textParagraph8]),
            UIHelper.verticalSpaceMedium(),
            Row(
              children: <Widget>[
                Checkbox(
                    tristate: false,
                    onChanged: (value) {
                      consentState.consented = value;
                    },
                    value: consentState.consented),
                Flexible(
                  child: Text(
                      "Ich bin damit einverstanden, an der Studie teilzunehmen und stimme der Erhebung von pseudonymisierten Daten im Kontext der Studie zu"),
                ),
              ],
            ),
            buildSubmitButton()
          ],
        )),
      ),
    );
  }
}
