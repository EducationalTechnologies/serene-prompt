import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class VersionInfo extends StatefulWidget {
  @override
  _VersionInfoState createState() => _VersionInfoState();
}

class _VersionInfoState extends State<VersionInfo> {
  String versionNumber = "";

  VersionInfoState() {}

  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      setState(() {
        versionNumber = "v.$version+$buildNumber";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text("$versionNumber");
  }
}
