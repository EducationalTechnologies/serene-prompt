import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/settings_view_model.dart';
import 'package:serene/widgets/serene_drawer.dart';

class SettingsScreen extends StatelessWidget {
  _submit(SettingsViewModel vm) {
    vm.submit();
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<SettingsViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Einstellungen'),
          centerTitle: true,
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton(
                // textColor: Colors.white,
                // icon: const Icon(Icons.save),
                child: Text("Speichern"),
                onPressed: () async => _submit(vm))
          ],
        ),
        drawer: SereneDrawer(),
        body: Container(
            child: ListView(
          children: <Widget>[
            UIHelper.verticalSpaceLarge(),
            UIHelper.buildSubHeader("Wörter pro Minute"),
            Slider(
              label: vm.wordsPerMinute.toString(),
              divisions: 20,
              min: 100,
              max: 400,
              onChangeEnd: (value) async {
                await vm.submit();
              },
              onChanged: (value) {
                vm.setWordsPerMinute(value);
              },
              value: vm.wordsPerMinute,
            )
          ],
        )));
  }
}
