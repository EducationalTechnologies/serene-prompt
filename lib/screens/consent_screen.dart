import 'package:flutter/material.dart';
import 'package:serene/shared/ui_helpers.dart';

// TODO: Use markdown
class ConsentScreen extends StatelessWidget {
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
      "Serene ist eine Applikation mit der Lernziele erstellt und verfolgt werden können. Um diese Prozesse sammeln wir die folgenden Daten: ";
  List<String> _dataCollectionAggregated = [
    "Anzahl der Lernziele",
    "Zeitpläne für die Lernziele",
    "Fortschritt beim Erreichen der Lernziele"
  ];
  String _textParagraph6 = "TODO Daten beschreiben die wir sammeln";

  String _subheaderWhatHappensWithData =
      "Was passiert mit den Daten die über mich gesammelt werden?";
  List<String> _textWhatHappensWithData = [
    "Die Daten werden während des Semesters gesammelt und anschließend vollständig anonym für die wissenschaftliche Forschung verwendet. Lehrpersonal erhält keinen Zugriff auf die Daten"
  ];

  String _subheaderWhichRights = "Welche Rechte habe ich?";
  String _textParagraph8 = "TODO Rechte beschreiben";
  buildSubheader(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 20),
    );
  }

  buildConsentCard(List<String> paragraphs) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          children: <Widget>[for (var text in paragraphs) Text(text)],
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
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: (ListView(
          children: <Widget>[
            buildSubheader("Einverständniserklärung"),
            buildConsentCard(_textIntroduction),
            buildSubheader(_subheaderPurposes),
            buildConsentCard(_textPurposes),
            buildSubheader(_subheaderWhichData),
            buildConsentCard([_textParagraph5, _textParagraph6]),
            buildSubheader(_subheaderWhatHappensWithData),
            buildConsentCard(_textWhatHappensWithData),
            buildSubheader(_subheaderWhichRights),
            buildConsentCard([_textParagraph8]),
            UIHelper.verticalSpaceMedium(),
            buildSubmitButton()
          ],
        )),
      ),
    );
  }
}
