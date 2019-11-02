class MaterializedPath {
  static const String SEP = "/";

  static String toPathString(String id) {
    return "$SEP$id";
  }

  static List<String> getPathAsList(String path) {
    var pathList = path.split(SEP);
    pathList.removeWhere((p) => p.isEmpty);
    return pathList;
  }

  static String pathFromList(List<String> path) {
    return path.fold("", (prev, element) => prev + SEP + element);
  }

  static int getDepth(String path) {
    return getPathAsList(path).length;
  }

  static String addToPath(String existing, String newSegment) {
    return "$existing$newSegment";
  }

  static pathTreeFromPathList(List<String> paths) {
    var tree = [];

    for (var i = 0; i < paths.length; i++) {
      var pathList = MaterializedPath.getPathAsList(paths[i]);
      var currentNode = tree;
      for (var j = 0; j < pathList.length; j++) {
        var wantedNode = pathList[j];
        var lastNode = currentNode;

        for (var k = 0; k < currentNode.length; k++) {
          if (currentNode[k]["id"] == wantedNode) {
            currentNode = currentNode[k]["children"];
          }
        }

        if (lastNode == currentNode) {
          var newNode = {"id": wantedNode, "children": []};
          currentNode.add(newNode);
          currentNode = newNode["children"];
        }
      }
    }

    return tree;
  }

  static depthFirstFromTree(List<dynamic> tree) {
    var res = [];

    for (var node in tree) {
      res.add(node["id"]);
      res.addAll(depthFirstFromTree(node["children"]));
    }

    return res;
  }
}
