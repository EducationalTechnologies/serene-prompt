import 'package:flutter/material.dart';
import 'package:implementation_intentions/shared/app_colors.dart';
import 'package:implementation_intentions/speech/speech_recognition.dart';

class SpeechInternalisation extends StatefulWidget {
  @override
  _SpeechInternalisationState createState() => _SpeechInternalisationState();
}

class _SpeechInternalisationState extends State<SpeechInternalisation> {
  // SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  String locale = "en_US";
  String resultText = "";

  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();

    // Speechrecognition spch = Speechrecognition();
  }

  void initSpeechRecognizer() {
    // _speechRecognition = SpeechRecognition();

    // _speechRecognition.setAvailabilityHandler(
    //     (bool result) => setState(() => _isAvailable = result));

    // _speechRecognition.setRecognitionStartedHandler(
    //     () => setState(() => _isListening = true));

    // _speechRecognition.setRecognitionResultHandler(
    //     (String speech) => setState(() => resultText = speech));

    // _speechRecognition.setRecognitionCompleteHandler(recognitionComplete);

    // _speechRecognition.setErrorHandler(speechRecognitionError);

    // _speechRecognition
    //     .activate()
    //     .then((result) => setState(() => {_isAvailable = result}));
  }

  void speechRecognitionError(SpeechErrorEnum error) {
    print("Speech Recognition Error: $error");
  }

  void recognitionComplete(result) {
    print("Recognition Complete with Result: $result");
    setState(() => _isListening = false);
  }

  void startListening() {
    // _speechRecognition
    //     .listen(locale: locale)
    //     .then((result) => print("Start Listening, Result is $result"));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.cancel),
              mini: true,
              backgroundColor: Colors.deepOrange,
              onPressed: () {
                // if (_isListening) var
                // _speechRecognition.cancel().then((result) => setState(() {
                //       _isListening = result;
                //       resultText = "";
                //     }));
              },
            ),
            FloatingActionButton(
              child: Icon(Icons.mic),
              backgroundColor: Colors.pink,
              onPressed: () {
                if (_isAvailable && !_isListening) {
                  startListening();
                }
              },
            ),
            FloatingActionButton(
              child: Icon(Icons.stop),
              mini: true,
              backgroundColor: Colors.deepPurple,
              onPressed: () {
                // if (_isListening)
                // _speechRecognition
                //     .stop()
                //     .then((result) => setState(() => _isListening = result));
              },
            )
          ],
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: Colors.cyanAccent[100],
                borderRadius: BorderRadius.circular(6.0)),
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Text(
              resultText,
              style: TextStyle(fontSize: 24.0),
            )),
        GestureDetector(
            onLongPressStart: (details) {},
            onLongPressEnd: (details) {},
            child: SizedBox(
                width: double.infinity,
                height: 80,
                child: RaisedButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(55.0)),
                  child: Text(_isListening ? "Start Speaking" : "Not Recording",
                      style: TextStyle(fontSize: 20)),
                ))),
      ],
    );
  }
}
