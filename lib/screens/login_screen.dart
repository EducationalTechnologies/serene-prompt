import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/state/app_state.dart';
import 'package:serene/state/login_state.dart';

class LoginScreen extends StatefulWidget {
  final Color backgroundColor1;
  final Color backgroundColor2;
  final Color highlightColor;
  final Color foregroundColor;
  final AssetImage logo;

  LoginScreen(
      {Key k,
      this.backgroundColor1,
      this.backgroundColor2,
      this.highlightColor,
      this.foregroundColor,
      this.logo});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _userIdTextController;

  @override
  void initState() {
    super.initState();
    // _userIdTextController = TextEditingController();
  }

  _loginClick(BuildContext context) async {
    // final appState = Provider.of<AppState>(context);
    // final loginState = Provider.of<LoginState>(context);
    // await appState.userService.saveUsername(_userIdTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildControls(context),
    );
  }

  Widget buildControls(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final loginState = Provider.of<AppState>(context);

    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: Alignment.topLeft,
          end: new Alignment(
              1.0, 0.0), // 10% of the width, so there are ten blinds.
          colors: [
            this.widget.backgroundColor1,
            this.widget.backgroundColor2
          ], // whitish to gray
          // tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 150.0, bottom: 50.0),
            child: Center(
              child: new Column(
                children: <Widget>[
                  Container(
                    height: 128.0,
                    width: 128.0,
                    child: new CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: this.widget.foregroundColor,
                      radius: 100.0,
                      child: new Text(
                        "S",
                        style: TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: this.widget.foregroundColor,
                        width: 1.0,
                      ),
                      shape: BoxShape.circle,
                      //image: DecorationImage(image: this.logo)
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new Text(
                      "Serene",
                      style: TextStyle(color: this.widget.foregroundColor),
                    ),
                  )
                ],
              ),
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: this.widget.foregroundColor,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
                  child: Icon(
                    Icons.alternate_email,
                    color: this.widget.foregroundColor,
                  ),
                ),
                new Expanded(
                  child: TextField(
                    controller: _userIdTextController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username wählen',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // new Container(
          //   width: MediaQuery.of(context).size.width,
          //   margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(
          //     border: Border(
          //       bottom: BorderSide(
          //           color: this.foregroundColor,
          //           width: 0.5,
          //           style: BorderStyle.solid),
          //     ),
          //   ),
          //   padding: const EdgeInsets.only(left: 0.0, right: 10.0),
          //   child: new Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       new Padding(
          //         padding:
          //             EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
          //         child: Icon(
          //           Icons.lock_open,
          //           color: this.foregroundColor,
          //         ),
          //       ),
          //       new Expanded(
          //         child: TextField(
          //           obscureText: true,
          //           textAlign: TextAlign.center,
          //           decoration: InputDecoration(
          //             border: InputBorder.none,
          //             hintText: '*********',
          //             hintStyle: TextStyle(color: this.foregroundColor),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          new Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
            alignment: Alignment.center,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new RaisedButton(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    onPressed: () async {
                      // await _loginClick(context);
                      // Navigator.pushNamed(context, RouteNames.MAIN);
                    },
                    child: Text(
                      "Log In",
                    ),
                  ),
                ),
              ],
            ),
          ),
          // new Container(
          //   width: MediaQuery.of(context).size.width,
          //   margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
          //   alignment: Alignment.center,
          //   child: new Row(
          //     children: <Widget>[
          //       new Expanded(
          //         child: new FlatButton(
          //           padding: const EdgeInsets.symmetric(
          //               vertical: 20.0, horizontal: 20.0),
          //           color: Colors.transparent,
          //           onPressed: () => {},
          //           child: Text(
          //             "Forgot your password?",
          //             style: TextStyle(
          //                 color: this.foregroundColor.withOpacity(0.5)),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          new Expanded(
            child: Divider(),
          ),
          // new Container(
          //   width: MediaQuery.of(context).size.width,
          //   margin: const EdgeInsets.only(
          //       left: 40.0, right: 40.0, top: 10.0, bottom: 20.0),
          //   alignment: Alignment.center,
          //   child: new Row(
          //     children: <Widget>[
          //       new Expanded(
          //         child: new FlatButton(
          //           padding: const EdgeInsets.symmetric(
          //               vertical: 20.0, horizontal: 20.0),
          //           color: Colors.transparent,
          //           onPressed: () => {},
          //           child: Text(
          //             "Don't have an account? Create One",
          //             style: TextStyle(
          //                 color: this.foregroundColor.withOpacity(0.5)),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
