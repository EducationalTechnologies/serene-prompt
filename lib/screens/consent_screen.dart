import 'package:flutter/material.dart';
import 'package:implementation_intentions/shared/ui_helpers.dart';

class ConsentScreen extends StatelessWidget {
  String _textParagraph1 =
      "Einverständniserklärung für das Sammeln und die Verarbeitung von Daten im Rahmen des 'Serene' Forschungsprojektes der Educational Technologies Gruppe am DIPF | Leibniz-Institut für Bildungsforschung und Bildungsinformation";

  String _subheaderPurposes = "Zweck der Datensammlung";
  String _textParagraph2 =
      "Das Sammeln von Daten im Rahmen des Serene Projektes verfolgt die folgenden Ziele: ";
  String _textParagraph3 =
      "Den individuellen Lernfortschritt zu untersuchen und zu unterstützen. Wir geben Ihnen die Möglichkeit, Ihr persönliches Lernverhalten mit Ihren Zielen zu vergleichen. Sie können somit ihr Lernverhalten reflektieren und dadurch verbessern.";
  String _textParagraph4 = "TODO Lernforschung beschreiben";

  String _subheaderWhichData = "Welche Daten werden gesammelt?";
  String _textParagraph5 = "TODO Serene beschreiben";
  String _textParagraph6 = "TODO Daten beschreiben die wir sammeln";

  String _subheaderWhatHappensWithData =
      "Was passiert mit den Daten die über mich gesammelt werden?";
  String _textParagraph7 =
      "TODO Daten werden während des Semesters gesammelt und mit niemandem geteilt";

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
            buildConsentCard([_textParagraph1]),
            buildSubheader(_subheaderPurposes),
            buildConsentCard(
                [_textParagraph2, _textParagraph3, _textParagraph4]),
            buildSubheader(_subheaderWhichData),
            buildConsentCard([_textParagraph5, _textParagraph6]),
            buildSubheader(_subheaderWhatHappensWithData),
            buildConsentCard([_textParagraph7]),
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
