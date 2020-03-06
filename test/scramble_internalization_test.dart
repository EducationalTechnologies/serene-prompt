import 'package:flutter_test/flutter_test.dart';
import 'package:serene/screens/internalisation/scramble_internalisation.dart';

void main() {
  test("Correct sentence should be available after scramble", () {
    String inputSentence =
        "This is a long sentence that should be adequadetly scrambled except for in very rare circumstances where random chance produces the correct order";

    List<ScrambleText> correctScrambled =
        ScrambleText.scrambleTextListFromString(inputSentence, 3);
    String correctSentence =
        ScrambleText.stringFromScrambleTextList(correctScrambled);
    // print(correctScrambled);
    // correctSentence = correctScrambled.join("-");
    expect(correctSentence, inputSentence);
  });
}
