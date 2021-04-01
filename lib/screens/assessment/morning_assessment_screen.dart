import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/models/assessment.dart';
import 'package:serene/screens/assessment/daily_learning_question_screen.dart';
import 'package:serene/screens/assessment/free_text_question.dart';
import 'package:serene/screens/assessment/questionnaire.dart';
import 'package:serene/screens/initialsession/initial_assessment_screen.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/morning_assessment_view_model.dart';
import 'package:serene/widgets/full_width_button.dart';
import 'package:serene/widgets/serene_appbar.dart';
import 'package:serene/widgets/serene_drawer.dart';

class MorningAssessmentScreen extends StatefulWidget {
  MorningAssessmentScreen({Key key}) : super(key: key);

  @override
  _MorningAssessmentScreenState createState() =>
      _MorningAssessmentScreenState();
}

class _MorningAssessmentScreenState extends State<MorningAssessmentScreen> {
  final _controller = new PageController();
  final _kDuration = const Duration(milliseconds: 100);
  final _kCurve = Curves.ease;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    var vm = Provider.of<MorningAssessmentViewModel>(context, listen: false);

    _pages = [
      _buildAssessmentFuture(AssessmentTypes.dailyLearningIntention),
      FreeTextQuestion("Warum möchtest du heute nicht mit cabuu lernen?",
          textChanged: vm.onNotLearningReasonChanged),
      _buildAssessmentFuture(AssessmentTypes.success),
      _buildAssessmentFuture(AssessmentTypes.affect),
      _buildAssessmentFuture(AssessmentTypes.dailyObstacle),
      buildFinish(),
    ];

    vm.currentPageType = _pages[0].runtimeType;

    /// Attach a listener which will update the state and refresh the page index
    _controller.addListener(() {
      // _setCurrentPage();
    });
  }

  int _getCurrentPage() {
    if (_controller.hasClients) {
      return _controller.page.toInt();
    } else {
      return 0;
    }
  }

  _onAssessmentFinished(AssessmentTypes assessmentType, String id, String val) {
    setState(() {});
  }

  _buildAssessmentFuture(AssessmentTypes assessmentTypes) {
    var vm = Provider.of<MorningAssessmentViewModel>(context, listen: false);
    return FutureProvider<Assessment>(
        initialData: Assessment(),
        create: (context) => vm.getAssessment(assessmentTypes),
        child: Consumer<Assessment>(builder: (context, asssessment, _) {
          return Questionnaire(asssessment, vm.setAssessmentResult);
        }));
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

  buildPageView() {
    var vm = Provider.of<MorningAssessmentViewModel>(context);
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

  buildSubmitButton() {
    var vm = Provider.of<MorningAssessmentViewModel>(context, listen: false);
    return FullWidthButton(onPressed: () async {
      await vm.submit();
      // Navigator.pushNamed(context, RouteNames.NO_TASKS);
    });
  }

  _buildBottomNavigation() {
    var vm = Provider.of<MorningAssessmentViewModel>(context);
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: vm.canMoveBack(
                _getCurrentPage()), // _index > 1 && _index < _pages.length - 1,
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
            visible: vm.canMoveNext(_getCurrentPage()),
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
                if (vm.canMoveNext(_getCurrentPage())) {
                  _controller.jumpToPage(vm.getNextPage(_getCurrentPage()));
                  // _controller.animateToPage(
                  //     vm.getNextPage(_controller.page.toInt()),
                  //     duration: _kDuration,
                  //     curve: _kCurve);
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

  buildFinish() {
    return Container(
      margin: UIHelper.getContainerMargin(),
      child: Column(
        children: [
          Text(
            "Vielen Dank, dass du die Fragen beantwortet hast. Jetzt geht es weiter zu dem heutigen Merkspiel",
          ),
          FullWidthButton(
              text: "Abschicken",
              onPressed: () {
                var vm = Provider.of<MorningAssessmentViewModel>(context,
                    listen: false);
                if (vm.state == ViewState.idle) {
                  vm.submit();
                }
              })
        ],
      ),
    );
  }
}
