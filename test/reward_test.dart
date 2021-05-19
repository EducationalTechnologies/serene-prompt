import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Rewards should round down to nearest 5", () {
    var streak = 17;
    var newStreak = ((streak / 5).floor() * 5);
    expect(newStreak, 15);

    streak = 21;
    newStreak = ((streak / 5).floor() * 5);
    expect(newStreak, 20);

    streak = 0;
    newStreak = ((streak / 5).floor() * 5);
    expect(newStreak, 0);
  });
}
