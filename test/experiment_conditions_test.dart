import 'package:flutter_test/flutter_test.dart';
import 'package:serene/services/experiment_service.dart';

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
      expect(conditionValue, 2);
    });
  });

  group("Scheduling of notifications", () {
    test("Schedule of recall task should be postponed to the same day at four",
        () {
      var expService = ExperimentService(null, null);

      var now = DateTime.now();
      var dateTooEarly = DateTime(now.year, now.month, now.day, 8, 30);

      var date = expService.getScheduleTimeForRecallTask(dateTooEarly);

      expect(date.hour, 16);
    });
  });
}
