import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Experiment Conditions", () {
    test("Experimental condition should be 0", () {
      var dateOfLastInternalisation =
          DateTime.now().subtract(Duration(days: 3));

      var now = DateTime.now();
      var daysSince = now.difference(dateOfLastInternalisation).inDays;
      var conditionValue = daysSince % 3;
      expect(conditionValue, 0);
    });

    test("Experimental condition should be 2", () {
      var dateOfLastInternalisation =
          DateTime.now().subtract(Duration(days: 2));

      var now = DateTime.now();
      var daysSince = now.difference(dateOfLastInternalisation).inDays;
      var conditionValue = daysSince % 3;
      expect(conditionValue, 0);
    });
  });
}
