import 'package:flutter/material.dart';
import 'package:serene/shared/enums.dart';
// import 'package:url_launcher/url_launcher.dart';

class Resource {
  String url;
  String description;
  String title;
  String resourceType;

  Resource(
      {this.description,
      this.url,
      this.title,
      this.resourceType = ResourceType.link});
}

class ResourceLinksScreen extends StatelessWidget {
  final List<Resource> resources = [
    Resource(
      title: "Indistractable",
      description: "How to become less distracted",
      resourceType: ResourceType.link,
      url:
          "https://onezero.medium.com/being-indistractable-will-be-the-skill-of-the-future-a07780cf36f4",
    ),
    Resource(
        title: "The Now Habit",
        description: "A strategic program to beat procrastination",
        url: ""),
    Resource(
        title: "Heute fange ich wirklich an!",
        description: "Ein Ratgeber um chronisches Aufschieben zu überwinden",
        url:
            "https://www.hogrefe.de/shop/heute-fange-ich-wirklich-an-75870.html",
        resourceType: ResourceType.book),
    Resource(
      title: "Getting Things Done",
      description: "Methoden zum effizienten und belastungsfreien Arbeiten",
      url: "https://de.wikipedia.org/wiki/Getting_Things_Done",
      resourceType: ResourceType.link,
    ),
    Resource(
        title: "The Now Habit",
        description: "A strategic program to beat procrastination",
        url: ""),
    Resource(
        title: "The Now Habit",
        description: "A strategic program to beat procrastination",
        url: "")
  ];

  getIconByResourceType(String resourceType) {
    if (resourceType == ResourceType.link) return Icons.link;
    if (resourceType == ResourceType.book) return Icons.book;
  }

  buildResourceLink(Resource resource) {
    return Card(
      child: ListTile(
        leading: Icon(getIconByResourceType(resource.resourceType)),
        title: Text(resource.title),
        subtitle: Text(resource.description),
        isThreeLine: true,
        onTap: () async {
          // await launch(url);
          // if (await canLaunch(resource.url)) {
          //   await launch(resource.url);
          // } else {
          //   throw 'Could not launch $resource.url';
          // }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: <Widget>[
        for (var resource in resources) buildResourceLink(resource)
      ],
    ));
  }
}
