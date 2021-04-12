import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        TextButton(
            onPressed: () {
              showHelpDialog();
            },
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

  showHelpDialog() async {
    String textHelpRecall =
        "Wenn du nicht verstehst was du hier tun sollst, melde dich telefonisch bei **Jasmin Breitwieser: 069 24708 375**";

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        title: new Text("Hilfe"),
        content: new Column(
          children: [
            MarkdownBody(data: textHelpRecall),
          ],
        ),
        actions: <Widget>[
          new ElevatedButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
