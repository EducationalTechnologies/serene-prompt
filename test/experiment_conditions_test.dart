import 'package:flutter_test/flutter_test.dart';
import 'package:prompt/services/data_service.dart';
import 'package:prompt/services/experiment_service.dart';

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
    var expService = ExperimentService(null, null, null, null, null);
    var now = DateTime.now();

    test("Schedule of recall task should be postponed six hours", () {
      var dateTooEarly = DateTime(now.year, now.month, now.day, 8, 30);

      var date = expService.getScheduleTimeForRecallTask(dateTooEarly);

      expect(date.hour, 14);
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
  test("LDTs should match", () {
    var dataService = DataService(null, null, null);
    var expService = ExperimentService(dataService, null, null, null, null);

    //previously, 2 plans have been completed, so now we want to get the third one
    var previouslyCompleted = 16;

    // third day, group 2
    // var trialIndex = await expService.getLdtData()
  });
}
