import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Resource {
  String url;
  String description;
  String title;
  String resourceType;

  Resource({this.description, this.url, this.title, this.resourceType});
}

class ResourceLinksScreen extends StatelessWidget {
  final List<Resource> resources = [
    Resource(
      title: "Indistractable",
      description: "How to become less distracted",
      url:
          "https://onezero.medium.com/being-indistractable-will-be-the-skill-of-the-future-a07780cf36f4",
    ),
    Resource(
        title: "The Now Habit",
        description: "A strategic program to beat procrastination",
        url: ""),
    Resource(
        title: "The Now Habit",
        description: "A strategic program to beat procrastination",
        url: ""),
    Resource(
        title: "The Now Habit",
        description: "A strategic program to beat procrastination",
        url: ""),
    Resource(
        title: "The Now Habit",
        description: "A strategic program to beat procrastination",
        url: ""),
    Resource(
        title: "The Now Habit",
        description: "A strategic program to beat procrastination",
        url: "")
  ];

  buildResourceLink(String title, String description, String url) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.nature),
        title: Text(title),
        subtitle: Text(description),
        isThreeLine: true,
        onTap: () async {
          // await launch(url);
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: <Widget>[
        for (var resource in resources)
          buildResourceLink(resource.title, resource.description, resource.url)
      ],
    ));
  }
}
