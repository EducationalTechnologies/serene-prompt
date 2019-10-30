class MaterializedPath {
  static List<String> getPathAsList(String path) {
    var pathList = path.split("/");
    pathList.removeWhere((p) => p.isEmpty);
    return pathList;
  }

  static String pathFromList(List<String> path) {
    return path.fold("", (prev, element) => prev + "/" + element);
  }

  static int getDepth(String path) {
    return getPathAsList(path).length;
  }
}
