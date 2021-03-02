import 'package:flutter/material.dart';
import 'package:serene/widgets/speech_bubble.dart';

class TextExplanationScreen extends StatelessWidget {
  final String text;

  const TextExplanationScreen(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SpeechBubble(
            text: text,
          )
        ],
      ),
    );
  }
}
