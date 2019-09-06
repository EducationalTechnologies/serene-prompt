import 'package:flutter/material.dart';

class ConsentScreen extends StatelessWidget {
  buildConsentCard(String text) {
    return Card(
      child: Container(
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (ListView(
        children: <Widget>[
          Text("Declaration of consent"),
          Container(
              child: buildConsentCard(
                  "Declaration of consent for Prof. Dr. Drachsler and the Educational Technologies research team consisting of George Ciordas-Hertel, Daniel Biedermann, and Jan Schneider from the"))
        ],
      )),
    );
  }
}
