import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/edit_tags_view_model.dart';
import 'package:serene/widgets/serene_drawer.dart';

class EditTagsScreen extends StatelessWidget {
  const EditTagsScreen({Key key}) : super(key: key);

  _submit(EditTagsViewModel vm) {}

  _buildTagWidget(String tag) {
    return Container(
      child: Row(
        children: <Widget>[Text(tag)],
      ),
    );
  }

  _buildAddTagButton(EditTagsViewModel vm) {
    return RaisedButton(
      onPressed: () => _submit(vm),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
      child: vm.state == ViewState.idle
          ? Text("Neues Tag", style: TextStyle(fontSize: 20))
          : CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<EditTagsViewModel>(context);
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
            margin: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                UIHelper.verticalSpaceLarge(),
                UIHelper.buildSubHeader("Wörter pro Minute"),
                for (var tag in vm.tags) _buildTagWidget(tag),
                _buildAddTagButton(vm)
              ],
            )));
  }
}
