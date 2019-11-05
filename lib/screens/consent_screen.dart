import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/consent_state.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';

class ConsentScreen extends StatelessWidget {
  final List<String> _textIntroduction = [
    "Einverständniserklärung für das Sammeln und die Verarbeitung von Daten im Rahmen des 'Serene' Forschungsprojektes der Educational Technologies Gruppe am DIPF | Leibniz-Institut für Bildungsforschung und Bildungsinformation"
  ];

  final String _subheaderPurposes = "Zweck der Datensammlung";

  final List<String> _textPurposes = [
    "Das Sammeln von Daten im Rahmen des Serene Projektes verfolgt die folgenden Ziele: ",
    "Den individuellen Lernfortschritt zu untersuchen und zu unterstützen. Wir geben Ihnen die Möglichkeit, Ihr persönliches Lernverhalten mit Ihren Zielen zu vergleichen und somit vielleicht auch Ihren Lernfortschritt zu steigern.",
    "Um die Auswirkungen der Verwendung von Technologien auf Lernumgebungen zu untersuchen. Wir möchten herausfinden, welche Möglichkeiten durch die Verwendung von digitalen Lerntechnologien entstehen. Wir wollen diese Erkenntnisse nutzen um die angebotenen Technologien stetig zu verbessern",
    "Wir bieten in dieser Applikation eine Methode an, die sich 'Goal Shielding' nennt. Mit dieser Methode verbindet sich die Hoffnung, dass Sie Ablenkungen beim Lerner leichter widerstehen können. Wir möchten untersuchen, ob eine häufigere Anwendung dieser Methode zu größerer Zufriedenheit mit dem eigenen Lernfortschritt führt."
  ];

  final String _subheaderWhichData = "Welche Daten werden gesammelt?";
  final String _textParagraph5 =
      "Serene ist eine Applikation mit der Lernziele erstellt und verfolgt werden können. Sie können die Anwendung unter Nutzung eines selbstgewählten Pesudonyms nutzen, sodass ausschließlich **pseudonymisierte** Daten anfallen. Wir verwenden für unsere Forschung die folgenden in Serene anfallenden Daten: ";
  final List<String> _dataCollectionAggregated = [
    "* Text der Lernziele",
    "* Datum der Lernziele",
    "* Zeitpläne für die Lernziele",
    "* Der angegebene Fortschritt beim Erreichen der Lernziele",
    "* Antworten auf die Fragebögen",
    "* Clickstream Daten"
  ];
  final String _textParagraph6 =
      "In der Serene Applikation erheben und verwerten wir die folgenden Daten:";

  final String _subheaderWhatHappensWithData =
      "Was passiert mit den Daten die über mich gesammelt werden?";
  final List<String> _textWhatHappensWithData = [
    "Die Daten werden während des Semesters gesammelt und anschließend vollständig anonym für die wissenschaftliche Forschung verwendet. Insbesondere erhält das Lehrpersonal keinen Zugriff auf die Daten",
    "Für die Analyse der Daten werden diese in aggregierter Form aufbereitet, und die Forscher/innen werden diese statistisch untersuchen. Dabei wird untersucht, wie die gesetzten Lernziele und Lernzeiten in Verbindung zu einzelnen Funktionalitäten der Applikation stehen.",
    ""
  ];

  final String _subheaderWhatIsExpected = "Was wird von mir erwartet?";
  final List<String> _textWhatIsExpected = [
    "Sie können die Applikation frei verwenden und die Teilnahme an der Studie jederzeit beenden",
    "Während Sie die App installiert haben und verwenden, werden sie täglich an Ihre Lernpläne erinnert und gebeten, einen kurzen Fragebogen auszufüllen. Sie bestimmen somit selbst wie und wie oft Sie an der Studie teilnehmen"
  ];

  final String _subheaderWhatDoIGain =
      "Welche Vorteile kann ich daraus ziehen?";
  final List<String> _textWhatDoIGain = [
    "Sie erhalten möglicherweise Einsichten in Ihr eigenes Lernverhalten und vielleicht profitieren Sie auch schon direkt von einer planvolleren herangehensweise an Ihre Lernziele",
    "Darüber hinaus verlosen wir unter allen Teilnehmern vier Einkaufsgutscheine im Wert von je 25€. Die Teilnahme an diesem Gewinnspiel ist freiwillig. Allerdings benötigen wir dafür eine E-Mail Adresse, unter der wir Sie im Gewinnfall erreichen können. Mit jedem Tag, den sie die App benutzen (auch wenn sie der App nur mitteilen, dass sie am jeweiligen Tage nicht vorhaben zu lernen) wird Ihnen ein Los in der Verlosung gutgeschrieben. Sie werden im weiteren Verlauf der Verwendung dieser Applikation instruiert, wie Sie an dem Gewinnspiel konkret teilnehmen können. Die E-Mail Adresse mit der Sie an der Verlosung teilnehmen, wird nach Auslosung der Gewinne, spätestens zu Ende des laufenden Semesters (31.3.2020), gelöscht. Die E-Mail Adresse unter der Sie an dem Gewinnspiel teilnehmen, wird separat von den anderen Daten, die in der Verwendung der Applikation anfallen, gespeichert, und ausschließlich für die Verlosung verwendet."
  ];

  final String _subheaderWhichRights = "Welche Rechte habe ich?";
  final String _textRights1 =
      "Sie haben jederzeit die Möglichkeit folgende Rechte geltend zu machen: ";
  final List<String> _rights = [""];

  _buildSubheader(String text) {
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

  buildRightsCard() {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Welche Rechte habe ich?"),
            ),
            MarkdownBody(
                data:
                    "Sie haben jederzeit die Möglichkeit folgende Rechte geltend zu machen: "),
            MarkdownBody(
                data:
                    "* **Art. 7 Abs. 3 DSGVO: Recht auf Widerruf der Einwilligung** \n Sie haben das Recht, Ihre Einwilligung jederzeit mit Wirkung für die Zukunft zu widerrufen"),
            MarkdownBody(
                data:
                    "* **Art. 15 DSGVO: Auskunftsrecht** \n Sie haben uns gegenüber das Recht, Auskunft darüber zu erhalten, welche Daten wir zu Ihrer Person verarbeiten"),
            MarkdownBody(
                data:
                    "* **Art. 16 DSGVO: Recht auf Berichtigung** \n Sollten die Sie betreffenden Daten nicht richtig oder unvollständig sein, so können Sie die Berichtigung unrichtiger oder die Vervollständigung unvollständiger Angaben verlangen"),
            MarkdownBody(
                data:
                    "* **Art. 17 DSGVO: Recht auf Löschung** \n Sie können jederzeit die Löschung ihrer Daten verlangen"),
            MarkdownBody(
                data:
                    "* **Art. 18 DSGVO: Recht auf Einschränkung der Verarbeitung** \n Sie können die Einschränkung der Verarbeitung der Sie betreffenden personenbezogenen Daten verlangen"),
            MarkdownBody(
                data:
                    "* **Art. 21 DSGVO: Widerspruchsrecht** \n Sie können jederzeit gegen die Verarbeitung der Sie betreffenden Daten Widerspruch einlegen"),
            MarkdownBody(
                data:
                    "* **Art. 21 DSGVO: Recht auf Beschwerde bei einer Aufsichtsbehörde** \n Wenn Sie der Auffassung sind, dass wir bei der Verarbeitung Ihrer Daten datenschutzrechtliche Vorschriften nicht beachtet haben, können Sie sich  mit einer Beschwerde an die zuständige Aufsichtsbehörde wenden, die Ihre Beschwerde prüfen wird"),
          ],
        ),
      ),
    );
  }

  buildContactCard() {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Kontakt"),
            ),
            MarkdownBody(
                data:
                    "Um Ihre Rechte in Anspruch zu nehmen oder für generelle Rückfragen können Sie jederzeit Kontakt mit uns aufnehmen"),
            UIHelper.verticalSpaceSmall(),
            MarkdownBody(
                data:
                    "**Hauptverantwortlicher** : \n Daniel Biedermann \n DIPF | Leibniz-Institut für Bildungschforschung und Bildungsinformation \n Rostocker Straß 6 \n 60323 Frankfurt am Main \n 0049-69-24708-173 \n biedermann@dipf.de"),
            UIHelper.verticalSpaceSmall(),
            MarkdownBody(
                data:
                    "**Weitere Projektbeteiligte** \n Hendrik Drachsler, Jasmin Breitwieser, Leonard Tetzlaff, Garvin Brod \n DIPF | Leibniz-Institut für Bildungschforschung und Bildungsinformation "),
          ],
        ),
      ),
    );
  }

  _buildConsentCard(List<String> paragraphs) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          children: <Widget>[
            for (var text in paragraphs) MarkdownBody(data: text)
          ],
        ),
      ),
    );
  }

  buildSubmitButton(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        Navigator.pushNamed(context, RouteNames.LOG_IN);
      },
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
            _buildSubheader("Informierte Einwilligung"),
            _buildConsentCard(_textIntroduction),
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
            buildConsentCardWhichData(
                _subheaderWhatIsExpected, _textWhatIsExpected, []),
            buildConsentCardWhichData(
                _subheaderWhatDoIGain, _textWhatDoIGain, []),
            buildRightsCard(),
            UIHelper.verticalSpaceMedium(),
            buildContactCard(),
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
                      "Ich bin mir bewusst, dass ich meine Teilnahme an der Studie jederzeit beenden kann und mir dadurch keinerlei Nachteile entstehen."),
                ),
              ],
            ),
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
                      "Ich bin damit einverstanden, an der Studie teilzunehmen und stimme der Erhebung und Auswertung von pseudonymisierten Daten im Kontext der Studie zu"),
                ),
              ],
            ),
            buildSubmitButton(context)
          ],
        )),
      ),
    );
  }
}
