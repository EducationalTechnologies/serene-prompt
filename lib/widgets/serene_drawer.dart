import 'package:flutter/material.dart';
import 'package:implementation_intentions/services/database_helpers.dart';
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
              Navigator.pushNamed(context, NamedRoutes.ADD_GOAL);
            },
          ),
          ListTile(
            title: Text("Ziele"),
            onTap: () {
              Navigator.pushNamed(context, NamedRoutes.MAIN);
            },
          ),
          ListTile(
              title: Text("Goal Shielding"),
              onTap: () {
                Navigator.pushNamed(context, NamedRoutes.GOAL_SHIELDING);
              }),
          ListTile(
              title: Text("Clear Goals Database"),
              onTap: () async {
                await DBProvider.db.clearDatabase();
              }),
          ListTile(
              title: Text("Insert Sample Goals"),
              onTap: () async {
                await DBProvider.db.insertSampleData();
              }),
        ],
      ),
    );
  }
}
