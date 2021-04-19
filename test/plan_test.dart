import 'package:flutter_test/flutter_test.dart';
import 'package:prompt/services/data_service.dart';
import 'package:prompt/services/experiment_service.dart';
import 'package:prompt/shared/enums.dart';

void main() {
  test("planId on first day and first group should be 1", () async {
    var dataService = DataService(null, null, null);
    var expService = ExperimentService(dataService, null, null, null, null);

    //previously, 2 plans have been completed, so now we want to get the third one
    var previouslyCompleted = 0;

    // third day, group 2
    var plan = await expService.getTodaysPlan(previouslyCompleted, 1);

    expect(plan.planId, 1);
  });
  test("planId on third day and second group should be 19", () async {
    var dataService = DataService(null, null, null);
    var expService = ExperimentService(dataService, null, null, null, null);

    //previously, 2 plans have been completed, so now we want to get the third one
    var previouslyCompleted = 2;

    // third day, group 2
    var plan = await expService.getTodaysPlan(previouslyCompleted, 2);

    expect(plan.planId, 19);
  });
  test("Plan condition day 17, group 5 should be scramble", () async {
    var dataService = DataService(null, null, null);
    var expService = ExperimentService(dataService, null, null, null, null);

    //previously, 2 plans have been completed, so now we want to get the third one
    var previouslyCompleted = 16;

    // third day, group 2
    var plan = await expService.getTodaysInternalisationCondition(
        previouslyCompleted, 5);

    expect(plan, InternalisationCondition.scrambleWithHint);
  });
}
