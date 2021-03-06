import 'package:flutter/material.dart';
import 'package:prompt/widgets/speech_bubble.dart';

class TextExplanationScreen extends StatelessWidget {
  final String text;

  const TextExplanationScreen(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpeechBubble(
            text: text,
          )
        ],
      ),
    );
  }
}
