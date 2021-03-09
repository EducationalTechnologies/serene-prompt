import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/screens/initialsession/initial_assessment_screen.dart';
import 'package:serene/screens/initialsession/initial_obstacle_display_screen.dart';
import 'package:serene/screens/initialsession/initial_outcome_display_screen.dart';
import 'package:serene/screens/initialsession/initial_obstacle_explanation_screen.dart';
import 'package:serene/screens/initialsession/initial_ldt_screen.dart';
import 'package:serene/screens/initialsession/initial_outcome_explanation_screen.dart';
import 'package:serene/screens/initialsession/obstacle_enter_screen.dart';
import 'package:serene/screens/initialsession/obstacle_selection_screen.dart';
import 'package:serene/screens/initialsession/obstacle_sorting_screen.dart';
import 'package:serene/screens/initialsession/outcome_enter_screen.dart';
import 'package:serene/screens/initialsession/outcome_selection_screen.dart';
import 'package:serene/screens/initialsession/text_explanation_screen.dart';
import 'package:serene/screens/initialsession/outcome_sorting_screen.dart';
import 'package:serene/screens/initialsession/video_screen.dart';
import 'package:serene/screens/initialsession/welcome_screen.dart';
import 'package:serene/screens/initialsession/cabuu_link_screen.dart';
import 'package:serene/screens/initialsession/initial_daily_learning_goal_screen.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';
import 'package:serene/widgets/serene_appbar.dart';
import 'package:serene/widgets/serene_drawer.dart';

class InitialSessionScreen extends StatefulWidget {
  InitialSessionScreen({Key key}) : super(key: key);

  @override
  _InitialSessionScreenState createState() => _InitialSessionScreenState();
}

class _InitialSessionScreenState extends State<InitialSessionScreen> {
  final _controller = new PageController();
  final _kDuration = const Duration(milliseconds: 300);
  final _kCurve = Curves.ease;

  final List<Widget> _pages = [
    WelcomeScreen(), // Screen 1
    VideoScreen("QTSUm9LId7k"), // Screen 2
    CabuuLinkScreen(), // Screen 3
    InitialAssessmentScreen(Assessments.cabuuLearn), // Screen 4
    InitialAssessmentScreen(Assessments.regulation), // Screen 4
    VideoScreen("NfaDCzxoXGw"), // Screen 5
    InitialDailyLearningGoalScreen(), // Screen 6
    InitialAssessmentScreen(Assessments.learningGoals1), // Screen 6
    InitialOutcomeExplanationScreen(), // Screen 7
    OutcomeSelectionScreen(), // Screen 8
    OutcomeEnterScreen(), // Screen 9
    OutcomeSortingScreen(), // Screen 10
    InitialOutcomeDisplayScreen(), // Screen 11
    InitialObstacleExplanationScreen(), // Screen 12
    ObstacleSelectionScreen(), // Screen 13
    ObstacleEnterScreen(), // Screen 14
    ObstacleSortingScreen(), // Screen 15
    InitialObstacleDisplayScreen(), // Screen 16
    InitialAssessmentScreen(Assessments.srl),
    TextExplanationScreen("Reward krams"),
    InitialAssessmentScreen(Assessments.learningGoals2),
    TextExplanationScreen("Drittes Video"),
    InitialLdtScreen("0_0"),
    InitialLdtScreen("0_1"),
    InitialLdtScreen("0_2"),
    TextExplanationScreen("Viertes Video"),
    TextExplanationScreen("Reward krams"),
    // InitialAssessmentScreen(Assessments.cabuuLearn),
    // InitialAssessmentScreen(Assessments.regulation),
    // VideoScreen("Zweites Videeo"),
    // InitialAssessmentScreen(Assessments.selfEfficacy),
    // TextExplanationScreen(
    //     "Denke jetzt einmal darüber nach, was für dich persönlich das Beste daran wäre, wenn du es schaffen würdest, an X Tagen pro Woche Vokabeln zu lernen. Auf der nächsten Seite siehst du ein paar Vorschläge von uns. Wähle alles aus der Liste aus, was auf dich  zutrifft Sollte nichts darunter sein oder noch etwas Wichtiges fehlen, kannst du es auf der übernächsten Seite ergänzen."),
    // TextExplanationScreen(
    //     "TODO: [Anzeige des Outcomes auf Platz 1 der Sortierliste] Nimm dir jetzt einen kurzen Moment Zeit, um dir dieses beste Ergebnis so lebhaft wie möglich vorzustellen. Wie fühlt es sich an? Versetze dich ganz in die Situation hinein. Du kannst dafür auch kurz die Augen schließen. Wenn du fertig bist, drücke auf “Weiter”."),
    // OutcomeSelectionScreen(),
    // OutcomeEnterScreen(),
    // OutcomeSortingScreen(),
    // ObstacleSelectionScreen(),
    // ObstacleEnterScreen(),
    // ObstacleSortingScreen(),
    // TextExplanationScreen(
    //     "TODO: [Anzeige des Obstacles auf Platz 1 der Sortierliste] Was könntest du machen, um dieses Hindernis zu überwinden? Finde eine Handlung, die du ausführen kannst, oder einen Gedanken, den du denken kannst, um das Hindernis zu überwinden. Stelle dir dazu genau vor, wie du das Hindernis überwindest. Fasse diese Handlung oder den Gedanken in ein paar Stichworten zusammen.  [freie Texteingabe, ]"),
    // InitialAssessmentScreen(Assessments.goals),
    // TextExplanationScreen(
    //     "Danke für deine Mitarbeit bis hierhin! Du hast dir damit deine ersten 6 Punkte verdient! [anzeigen] Jetzt haben wir noch ein paar Fragen und eine Aufgabe für dich, dann hast du es geschafft"),
    // InitialAssessmentScreen(Assessments.screen19),
    // VideoScreen("Instruktionsvideo LDT"),
    // InitialExplanationScreen(),
  ];

  @override
  void initState() {
    super.initState();

    /// Attach a listener which will update the state and refresh the page index
    _controller.addListener(() {
      var vm = Provider.of<InitSessionViewModel>(context, listen: false);
      if (_controller.page.round() != vm.step) {
        setState(() {
          vm.step = _controller.page.round();
        });
      }
    });
  }

  _buildBottomNavigation() {
    var vm = Provider.of<InitSessionViewModel>(context);
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible:
                vm.canMoveBack(), // _index > 1 && _index < _pages.length - 1,
            child: TextButton(
              child: Row(
                children: <Widget>[
                  Icon(Icons.navigate_before),
                  Text(
                    "Zurück",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              onPressed: () {
                _controller.previousPage(duration: _kDuration, curve: _kCurve);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: vm.canMoveNext(),
            child: ElevatedButton(
              child: Row(
                children: <Widget>[
                  Text(
                    "Weiter",
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(Icons.navigate_next)
                ],
              ),
              onPressed: () {
                if (vm.canMoveNext()) {
                  // _controller.jumpToPage(vm.getNextPage());
                  _controller.animateToPage(vm.getNextPage(),
                      duration: _kDuration, curve: _kCurve);
                  // _controller.nextPage(duration: _kDuration, curve: _kCurve);
                }
                setState(() {});
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }

  buildSubmitButton() {
    var vm = Provider.of<InitSessionViewModel>(context, listen: false);
    return FullWidthButton(onPressed: () async {
      await vm.submit();
      Navigator.pushNamed(context, RouteNames.INTERNALISATION);
    });
  }

  buildPageView() {
    var vm = Provider.of<InitSessionViewModel>(context);
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Flexible(
            child: PageView.builder(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _pages[index];
              },
            ),
          ),
          if (vm.step < _pages.length - 1) _buildBottomNavigation(),
          if (vm.step == _pages.length - 1) buildSubmitButton()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: SereneAppBar(),
            drawer: SereneDrawer(),
            body: Container(child: buildPageView())));
  }
}
