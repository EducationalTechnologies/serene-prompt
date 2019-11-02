// based on https://gist.github.com/mikelehen/3596a30bd69384624c11
import 'dart:math';

const String _kPushChars =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
typedef String StringCallback();

class IdGenerator {
  StringCallback generatePushId = () {
    int lastPushTime = 0;
    final List<int> randomSuffix = new List<int>(12);
    final Random random = new Random.secure();

    String _toPushIdBase64(int value, int numChars) {
      List<String> chars = new List<String>(numChars);
      for (int i = numChars - 1; i >= 0; i -= 1) {
        chars[i] = _kPushChars[value % 64];
        value = (value / 64).floor();
      }
      assert(value == 0);
      return chars.join();
    }

    return () {
      final int now = new DateTime.now().toUtc().millisecondsSinceEpoch;
      String id = _toPushIdBase64(now, 8);

      if (now != lastPushTime) {
        for (int i = 0; i < 12; i += 1) {
          randomSuffix[i] = random.nextInt(64);
        }
      } else {
        int i;
        for (i = 11; i >= 0 && randomSuffix[i] == 63; i--) randomSuffix[i] = 0;
        randomSuffix[i] += 1;
      }
      final String suffixStr =
          randomSuffix.map((int i) => _kPushChars[i]).join();
      lastPushTime = now;

      return '$id$suffixStr';
    };
  }();
}
