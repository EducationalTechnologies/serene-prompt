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

    test("Path List should split at slash but not have empty element first", () {
      String path = "/zero0/one1/two2";

      var pathList = MaterializedPath.getPathAsList(path);

      expect(pathList[0], "zero0");
      expect(pathList[1], "one1");
      expect(pathList[2], "two2");
    });
  });
}
