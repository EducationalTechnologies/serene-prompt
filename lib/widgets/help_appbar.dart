import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prompt/shared/ui_helpers.dart';

class HelpAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;

  const HelpAppBar({Key key, this.title = ""}) : super(key: key);

  @override
  _HelpAppBarState createState() => _HelpAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50);
}

class _HelpAppBarState extends State<HelpAppBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        TextButton(
            onPressed: () {},
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              UIHelper.horizontalSpaceMedium(),
              Text("Hilfe"),
              Icon(Icons.help),
              UIHelper.horizontalSpaceMedium(),
            ])),
      ],
      title: Text(""),
      textTheme:
          TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 22)),
      centerTitle: true,
    );
  }
}
