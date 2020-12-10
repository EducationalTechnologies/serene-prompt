import 'package:flutter/widgets.dart';

class InitialSessionScreen extends StatefulWidget {
  InitialSessionScreen({Key key}) : super(key: key);

  @override
  _InitialSessionScreenState createState() => _InitialSessionScreenState();
}

class _InitialSessionScreenState extends State<InitialSessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Hier kommt jetzt irgendwas hin"),
    );
  }
}
