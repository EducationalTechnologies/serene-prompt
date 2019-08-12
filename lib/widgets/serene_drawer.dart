import 'package:flutter/material.dart';
import 'package:implementation_intentions/shared/route_names.dart';

class SereneDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text("Serene"),
            decoration: BoxDecoration(color: Colors.orange),
          ),
          ListTile(
            title: Text("Neues Ziel"),
            onTap: () {
              Navigator.pushNamed(context, MAIN);
            },
          ),
          ListTile(
            title: Text("Ziele"),
            onTap: () {
              Navigator.pushNamed(context, MAIN);
            },
          ),
          ListTile(
            title: Text("Reflektieren"),
            onTap: () {
              Navigator.pushNamed(context, MAIN);
            },
          ),
          ListTile(
              title: Text("Goal Shielding"),
              onTap: () {
                Navigator.pushNamed(context, GOAL_SHIELDING);
              }),
        ],
      ),
    );
  }
}
