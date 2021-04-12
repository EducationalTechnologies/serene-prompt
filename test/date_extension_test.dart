import 'package:flutter_test/flutter_test.dart';
import 'package:prompt/shared/extensions.dart';

void main() {
  test("Date Should be three days ago", () {
    var prior = DateTime.utc(2021, 1, 26, 13, 30);

    var comp = DateTime.utc(2021, 1, 29, 10, 30);

    var daysAgo = comp.weekDaysAgo(prior);

    expect(daysAgo, 3);
  });

  test("Date Should be two days in the future", () {
    var prior = DateTime.utc(2021, 2, 1, 10, 30);

    var comp = DateTime.utc(2021, 1, 30, 23, 30);

    var daysAgo = comp.weekDaysAgo(prior);

    expect(daysAgo, -2);
  });
}
