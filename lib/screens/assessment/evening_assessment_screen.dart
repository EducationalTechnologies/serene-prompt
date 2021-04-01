import 'package:flutter/widgets.dart';

class EveningAssessmentScreen extends StatefulWidget {
  EveningAssessmentScreen({Key key}) : super(key: key);

  @override
  _EveningAssessmentScreenState createState() =>
      _EveningAssessmentScreenState();
}

class _EveningAssessmentScreenState extends State<EveningAssessmentScreen> {
  final _controller = new PageController();
  final _kDuration = const Duration(milliseconds: 100);
  final _kCurve = Curves.ease;
  List<Widget> _pages = [];

  // @override
  // void initState() {
  //   super.initState();

  //   var vm = Provider.of<MorningAssessmentViewModel>(context, listen: false);

  //   _pages = [
  //     _buildAssessmentFuture(AssessmentTypes.dailyObstacle),
  //     _buildAssessmentFuture(AssessmentTypes.dailyLearningIntention),
  //     FreeTextQuestion("Warum möchtest du heute nicht mit cabuu lernen?",
  //         textChanged: vm.onNotLearningReasonChanged),
  //     _buildAssessmentFuture(AssessmentTypes.affect),
  //     InitialAssessmentScreen(
  //         AssessmentTypes.success, _onAssessmentFinished), // Screen 4
  //   ];

  //   vm.currentPageType = _pages[0].runtimeType;

  //   /// Attach a listener which will update the state and refresh the page index
  //   _controller.addListener(() {
  //     // _setCurrentPage();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("FUMPF"),
    );
  }
}
