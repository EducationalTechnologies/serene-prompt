import 'package:flutter/material.dart';
import 'package:prompt/widgets/help_appbar.dart';
import 'package:provider/provider.dart';
import 'package:prompt/screens/internalisation/emoji_story_screen.dart';
import 'package:prompt/screens/internalisation/help_screen.dart';
import 'package:prompt/screens/internalisation/scramble_internalisation.dart';
import 'package:prompt/screens/internalisation/waiting_internalisation_screen.dart';
import 'package:prompt/shared/enums.dart';
import 'package:prompt/viewmodels/internalisation_view_model.dart';

class InternalisationScreen extends StatefulWidget {
  InternalisationScreen({Key key}) : super(key: key);

  @override
  _InternalisationScreenState createState() => _InternalisationScreenState();
}

class _InternalisationScreenState extends State<InternalisationScreen> {
  @override
  void initState() {
    super.initState();
  }

  getScreenForCondition(InternalisationCondition condition) {
    var vm = Provider.of<InternalisationViewModel>(context);

    switch (condition) {
      case InternalisationCondition.waiting:
        return WaitingInternalisationScreen(vm.waitingDuration);
        break;
      case InternalisationCondition.scrambleWithHint:
        return ScrambleInternalisation(true);
        break;
      case InternalisationCondition.emoji:
        return EmojiStoryScreen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<InternalisationViewModel>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: FutureBuilder(
        future: vm.initialized,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: HelpAppBar(
                  getHelpTypeForCondition(vm.internalisationCondition),
                ),
                body: Container(
                  child: getScreenForCondition(vm.internalisationCondition),
                ));
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  getHelpTypeForCondition(InternalisationCondition condition) {
    switch (condition) {
      case InternalisationCondition.waiting:
        return HelpType.waitingInternalisation;
        break;
      case InternalisationCondition.scrambleWithHint:
        return HelpType.scrambleInternalisation;
        break;
      case InternalisationCondition.emoji:
        return HelpType.emojiInternalisation;
        break;
      default:
        return HelpType.general;
    }
  }
}
