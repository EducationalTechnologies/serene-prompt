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

  _buildTagWidget(String tag, EditTagsViewModel vm) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            tag,
            style: TextStyle(fontSize: 20),
          ),
          Expanded(child: Container()),
          FlatButton(
              child: Icon(Icons.edit), onPressed: () async => _submit(vm)),
          FlatButton(
              child: Icon(Icons.delete), onPressed: () async => _submit(vm))
        ],
      ),
    );
  }

  _buildAddTagButton(EditTagsViewModel vm) {
    return RaisedButton(
      onPressed: () => vm.mode = EditTagsMode.edit,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
      child: vm.state == ViewState.idle
          ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Icon(Icons.add),
              Text("Neues Tag", style: TextStyle(fontSize: 20))
            ])
          : CircularProgressIndicator(),
    );
  }

  _buildTagInput(EditTagsViewModel vm) {
    return Row(
      children: <Widget>[
        TextFormField(
          autofocus: true,
          style: TextStyle(fontSize: 20),
          onChanged: (text) {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<EditTagsViewModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Tags'),
          centerTitle: true,
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0.0,
          actions: <Widget>[
            FlatButton(
                // textColor: Colors.white,
                // icon: const Icon(Icons.save),
                child: Row(
                  children: <Widget>[
                    Text("Speichern"),
                  ],
                ),
                onPressed: () async => _submit(vm))
          ],
        ),
        drawer: SereneDrawer(),
        body: Container(
            margin: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                UIHelper.verticalSpaceLarge(),
                // UIHelper.buildSubHeader("Tags"),
                for (var tag in vm.tags) _buildTagWidget(tag, vm),
                if (vm.mode == EditTagsMode.edit)
                  _buildTagInput(vm),
                UIHelper.verticalSpaceLarge(),
                _buildAddTagButton(vm)
              ],
            )));
  }
}
