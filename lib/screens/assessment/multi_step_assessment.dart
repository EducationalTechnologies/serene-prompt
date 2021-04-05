import 'package:flutter/material.dart';
import 'package:serene/viewmodels/multi_step_assessment_view_model.dart';
import 'package:serene/shared/extensions.dart';
import 'package:serene/widgets/full_width_button.dart';

class MultiStepAssessment extends StatefulWidget {
  final MultiStepAssessmentViewModel vm;
  final List<Widget> pages;
  // final VoidCallback onSubmit;
  MultiStepAssessment(this.vm, this.pages, {Key key}) : super(key: key);

  @override
  _MultiStepAssessmentState createState() => _MultiStepAssessmentState();
}

class _MultiStepAssessmentState extends State<MultiStepAssessment> {
  final _controller = new PageController();
  final _kDuration = const Duration(milliseconds: 100);
  final _kCurve = Curves.ease;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      widget.vm.step = _controller.page.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _buildPageView());
  }

  _buildPageView() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Flexible(
            child: PageView.builder(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.pages.length,
              itemBuilder: (context, index) {
                return widget.pages[index];
              },
            ),
          ),
          if (widget.vm.step < widget.pages.length - 1)
            _buildBottomNavigation(),
          if (widget.vm.step == widget.pages.length - 1) _buildSubmitButton()
        ],
      ),
    );
  }

  _buildSubmitButton() {
    return FullWidthButton(onPressed: () async {
      widget.vm.submit();
      // // Navigator.pushNamed(context, RouteNames.NO_TASKS);
      //
      // this.widget.onSubmit();
    });
  }

  _buildBottomNavigation() {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: widget.vm.canMoveBack(
                _keyOfCurrent()), // _index > 1 && _index < _pages.length - 1,
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
            visible: widget.vm.canMoveNext(_keyOfCurrent()),
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
                if (widget.vm.canMoveNext(_keyOfCurrent())) {
                  _controller
                      .jumpToPage(widget.vm.getNextPage(_keyOfCurrent()));
                  widget.vm.clearCurrent();
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

  _keyOfCurrent() {
    if (widget.pages == null) {
      return ValueKey("");
    }
    if (widget.pages.length > 0) {
      return widget.pages[_controller.currentPageOrZero].key;
    }
    return ValueKey("");
  }
}
