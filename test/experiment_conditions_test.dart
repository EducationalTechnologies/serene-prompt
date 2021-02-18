import 'package:flutter/foundation.dart';
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

    test("LDT index calculation should be 0, 1, 2", () {
      var xps = ExperimentService(null, null, null, null, null);

      var dateOfFirst = DateTime.now().subtract(Duration(days: 2));

      var indices = xps.getTrialIndices(dateOfFirst);
      print(indices);
      expect(listEquals(indices, [0, 1, 2]), true);
    });
  });

  group("Scheduling of notifications", () {
    var expService = ExperimentService(null, null, null, null, null);
    var now = DateTime.now();

    test("Schedule of recall task should be postponed to the same day at four",
        () {
      var dateTooEarly = DateTime(now.year, now.month, now.day, 8, 30);

      var date = expService.getScheduleTimeForRecallTask(dateTooEarly);

      expect(date.hour, 16);
    });

    test(
        "Schedule of recall task should be ${ExperimentService.INTERNALISATION_RECALL_BREAK} hours after internalisation",
        () {
      var hours = 14;
      var dateTooEarly = DateTime(now.year, now.month, now.day, hours, 30);

      var date = expService.getScheduleTimeForRecallTask(dateTooEarly);

      expect(date.hour, hours + ExperimentService.INTERNALISATION_RECALL_BREAK);
    });

    test("No notification should be scheduled, because it is too late", () {
      var dateTooLate = DateTime(now.year, now.month, now.day, 20, 30);

      var shouldNot = expService.shouldScheduleRecallTaskToday(dateTooLate);

      expect(shouldNot, false);
    });

    test("should be scheduled", () {
      var dateEarlyEnough = DateTime(now.year, now.month, now.day, 16, 30);

      var should = expService.shouldScheduleRecallTaskToday(dateEarlyEnough);

      expect(should, true);
    });
  });
}
