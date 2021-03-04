// based on https://gist.github.com/mikelehen/3596a30bd69384624c11
import 'dart:math';

const String _kPushChars =
    '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
typedef String StringCallback();

class IdGenerator {
  static String _toPushIdBase64(int value, int numChars) {
    List<String> chars = List.filled(numChars, "a");
    for (int i = numChars - 1; i >= 0; i -= 1) {
      chars[i] = _kPushChars[value % _kPushChars.length];
      value = (value / _kPushChars.length).floor();
    }
    assert(value == 0);
    return chars.join();
  }

  static String generatePushId() {
    int lastPushTime = 0;
    final List<int> randomSuffix = List.filled(12, 1);
    final Random random = new Random.secure();

    final int now = new DateTime.now().toUtc().millisecondsSinceEpoch;
    String id = _toPushIdBase64(now, 8);

    if (now != lastPushTime) {
      for (int i = 0; i < 12; i += 1) {
        randomSuffix[i] = random.nextInt(_kPushChars.length);
      }
    } else {
      int i;
      for (i = 11; i >= 0 && randomSuffix[i] == _kPushChars.length - 1; i--)
        randomSuffix[i] = 0;
      randomSuffix[i] += 1;
    }
    final String suffixStr = randomSuffix.map((int i) => _kPushChars[i]).join();
    lastPushTime = now;

    return '$id$suffixStr';
  }
}
