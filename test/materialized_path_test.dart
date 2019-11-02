import 'package:flutter_test/flutter_test.dart';
import 'package:serene/shared/materialized_path.dart';

void main() {
  group("Materialized Path", () {
    test("Path count should be 3", () {
      String path = "/a/b/c";

      var depth = MaterializedPath.getDepth(path);

      expect(depth, 3);
    });

    test("Path should be constructed from list with slashes", () {
      List<String> path = ["a", "b", "c"];

      var pathString = MaterializedPath.pathFromList(path);

      expect(pathString, "/a/b/c");
    });

    test("Path List should split at slash but not have empty element first",
        () {
      String path = "/zero0/one1/two2";

      var pathList = MaterializedPath.getPathAsList(path);

      expect(pathList[0], "zero0");
      expect(pathList[1], "one1");
      expect(pathList[2], "two2");
    });

    test("Path segment should add to the end", () {
      String existing = "/zero0/one1/two2";
      String newSegment = MaterializedPath.toPathString("three3");

      var combinedPath = MaterializedPath.addToPath(existing, newSegment);

      expect(combinedPath, "/zero0/one1/two2/three3");
    });
  });

  group("Tree Construction", () {
    var id0 = "a";
    var id1 = "b";
    var id3 = "c";
    var id4 = "d";
    var id5 = "e";
    var id6 = "f";

    var p1 = MaterializedPath.toPathString(id0);
    var p2 = "/a/b";
    var p3 = "/a/b/c";
    var p4 = "/a/d";
    var p5 = "/a/e";
    var p6 = "/f";

    var paths = [p1, p2, p3, p4, p5, p6];
    var tree = MaterializedPath.pathTreeFromPathList(paths);
    var depthFirstList = MaterializedPath.depthFirstFromTree(tree);

    test("Tree should build", () {
      expect(tree[0]["id"], id0);
    });

    test("Tree should have all root children", () {
      expect(tree.length, 2);
    });

    test("First tree node should have children", () {
      expect(tree[0]["children"].length, 3);
    });

    test("Depth first list should reconstruct", () {
      expect(depthFirstList.length, 6);
      expect(depthFirstList[0], "a");
      expect(depthFirstList[1], "b");
      expect(depthFirstList[2], "c");
      expect(depthFirstList[3], "d");
      expect(depthFirstList[4], "e");
      expect(depthFirstList[5], "f");
    });
  });
}
