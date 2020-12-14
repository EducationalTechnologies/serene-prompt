import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SereneAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const SereneAppBar({Key key, this.title}) : super(key: key);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(title),
      textTheme:
          TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 22)),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50);
}
