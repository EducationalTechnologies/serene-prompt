import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:serene/models/tag.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/ui_helpers.dart';
import 'package:serene/viewmodels/edit_tags_view_model.dart';
import 'package:serene/widgets/serene_drawer.dart';

class EditTagsScreen extends StatefulWidget {
  const EditTagsScreen({Key key}) : super(key: key);

  @override
  _EditTagsScreenState createState() => _EditTagsScreenState();
}

class _EditTagsScreenState extends State<EditTagsScreen> {
  TextEditingController _newTagController;

  @override
  void initState() {
    super.initState();
    _newTagController = TextEditingController();
  }

  _submit(EditTagsViewModel vm) async {
    vm.saveNewTags();
  }

  _buildAppBar(BuildContext context, EditTagsViewModel vm) {
    return AppBar(
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
    );
  }

  _buildConfirmationDialog(
      BuildContext context, EditTagsViewModel vm, TagModel tag) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Löschen bestätigen"),
            content: Text("Möchtest du dieses Tag wirklich löschen?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Abbrechen"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Löschen"),
                onPressed: () async {
                  vm.deleteTag(tag);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _buildAddTagDialog(BuildContext context, EditTagsViewModel vm, TagModel tag) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 300,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text("Neuen Tag anlegen",
                      style: Theme.of(context).textTheme.headline5),
                  UIHelper.verticalSpaceLarge(),
                  TextFormField(
                    controller: _newTagController,
                    autofocus: true,
                    style: TextStyle(fontSize: 20),
                    onChanged: (text) {},
                  ),
                  UIHelper.verticalSpaceLarge(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // FlatButton(
                        //   child: Text("Abbrechen"),
                        //   onPressed: () {
                        //     Navigator.of(context).pop();
                        //   },
                        // ),
                        FlatButton(
                          child: Text("Speichern"),
                          onPressed: () async {
                            vm.addTag(_newTagController.text);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _editTagDialog(BuildContext context, EditTagsViewModel vm, TagModel tag) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 300,
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Text("Neuen Tag anlegen",
                      style: Theme.of(context).textTheme.headline),
                  UIHelper.verticalSpaceLarge(),
                  TextFormField(
                    controller: _newTagController,
                    autofocus: true,
                    style: TextStyle(fontSize: 20),
                    onChanged: (text) {},
                  ),
                  UIHelper.verticalSpaceLarge(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // FlatButton(
                        //   child: Text("Abbrechen"),
                        //   onPressed: () {
                        //     Navigator.of(context).pop();
                        //   },
                        // ),
                        FlatButton(
                          child: Text("Speichern"),
                          onPressed: () async {
                            vm.addTag(_newTagController.text);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  _buildTagWidget(BuildContext context, TagModel tag, EditTagsViewModel vm) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              tag.name,
              style: TextStyle(fontSize: 20),
            ),
          ),
          // Expanded(child: Container()),
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit), onPressed: () async => _submit(vm)),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async =>
                      _buildConfirmationDialog(context, vm, tag))
            ],
          ),
        ],
      ),
    );
  }

  _buildAddTagButton(BuildContext context, EditTagsViewModel vm) {
    return RaisedButton(
      onPressed: () {
        vm.mode = EditTagsMode.newTag;
        _buildAddTagDialog(context, vm, null);
      },
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
        Expanded(
          child: TextFormField(
            autofocus: true,
            style: TextStyle(fontSize: 20),
            onChanged: (text) {},
          ),
        ),
        FlatButton(
            child: Icon(Icons.cancel),
            onPressed: () async => vm.mode = EditTagsMode.view)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<EditTagsViewModel>(context);
    return Scaffold(
        appBar: _buildAppBar(context, vm),
        drawer: SereneDrawer(),
        body: Container(
            margin: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                UIHelper.verticalSpaceLarge(),
                // UIHelper.buildSubHeader("Tags"),
                for (var tag in vm.tags) _buildTagWidget(context, tag, vm),
                // if (vm.mode == EditTagsMode.newTag)
                //   _buildTagInput(vm),
                UIHelper.verticalSpaceLarge(),
                _buildAddTagButton(context, vm)
              ],
            )));
  }
}
