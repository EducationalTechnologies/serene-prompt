import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/shared/enums.dart';
import 'package:serene/shared/route_names.dart';
import 'package:serene/viewmodels/login_view_model.dart';

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
  TextEditingController _passwordTextController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _userIdTextController = TextEditingController();
    _passwordTextController = TextEditingController();

    Future.delayed(Duration.zero).then((val) {
      _userIdTextController.text =
          Provider.of<LoginViewModel>(context, listen: false).email ?? "";
    });
  }

  _buildErrorDialog(String title, String content) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Okay"),
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  _loginClick(LoginViewModel vm, BuildContext context) async {
    var signedIn = await vm.signIn(
        _userIdTextController.text, _passwordTextController.text);
    if (signedIn == RegistrationCodes.SUCCESS) {
      Navigator.pushNamed(context, RouteNames.MAIN);
      return;
    } else {
      var shouldCreate = await _buildErrorDialog("Anmeldedaten nicht gefunden",
          "Benutzername oder Passwort waren nicht korrekt");
      if (shouldCreate) {
        _registerClick(vm, context);
      }
    }
  }

  _registerClick(LoginViewModel vm, BuildContext context) async {
    var registered = await vm.register(
        _userIdTextController.text, _passwordTextController.text);
    if (registered == RegistrationCodes.SUCCESS) {
      Navigator.pushNamed(context, RouteNames.INIT_START);
    } else if (registered == RegistrationCodes.WEAK_PASSWORD) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildControls(context),
    );
  }

  buildCircleAvatar() {
    return Container(
      height: 128.0,
      width: 128.0,
      child: new CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundColor: this.widget.foregroundColor,
        radius: 100.0,
        backgroundImage: AssetImage('assets/icons/icon_256.png'),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        //image: DecorationImage(image: this.logo)
      ),
    );
  }

  buildUserIdField(BuildContext context) {
    return new Container(
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
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
            child: Icon(
              Icons.alternate_email,
              color: this.widget.foregroundColor,
            ),
          ),
          new Expanded(
            child: TextFormField(
              controller: _userIdTextController,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (text) {
                // Provider.of<LoginState>(context).userId =
              },
              validator: (String arg) {
                if (arg.length < 3) {
                  return "Please use 3 or more characters";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                // labelText: "Email",
                // alignLabelWithHint: true,
                border: InputBorder.none,
                hintText: 'Email Adresse eingeben',
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildPasswordInput(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
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
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 00.0),
            child: Icon(
              Icons.lock,
              color: this.widget.foregroundColor,
            ),
          ),
          new Expanded(
            child: TextFormField(
              controller: _passwordTextController,
              obscureText: true,
              maxLines: 1,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Passwort (min. 6 Zeichen)',
                hintStyle: TextStyle(color: this.widget.foregroundColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildSubmitButton(BuildContext context) {
    var vm = Provider.of<LoginViewModel>(context);
    return new RaisedButton(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      onPressed: () async {
        if (vm.validateEmail(_userIdTextController.text)) {
          if (vm.mode == SignInScreenMode.register) {
            await _registerClick(vm, context);
          } else {
            await _loginClick(vm, context);
          }
        } else {
          await _buildErrorDialog("Ungültige Email Adresse",
              "Bitte überprüfe die Schreibweise der angegebenen Email Adresse");
        }
      },
      child: vm.state == ViewState.idle
          ? Text(
              vm.mode == SignInScreenMode.register
                  ? "Registrieren"
                  : "Einloggen",
            )
          : CircularProgressIndicator(),
    );
  }

  _buildRegisterButton(BuildContext context) {
    var vm = Provider.of<LoginViewModel>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
      alignment: Alignment.center,
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: FlatButton(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  onPressed: () async {
                    _userIdTextController.text = "";
                    _passwordTextController.text = "";
                    vm.toRegisterScreen();
                  },
                  child: Text("Einen neuen Account anlegen"))),
        ],
      ),
    );
  }

  _buildAlreadyHaveAccountButton(BuildContext context) {
    var vm = Provider.of<LoginViewModel>(context, listen: false);
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
      alignment: Alignment.center,
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: FlatButton(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  onPressed: () async {
                    _userIdTextController.text = "";
                    _passwordTextController.text = "";
                    vm.toSignInScreen();
                  },
                  child: Text("Ich habe bereits einen Account"))),
        ],
      ),
    );
  }

  Widget buildControls(BuildContext context) {
    var vm = Provider.of<LoginViewModel>(context);
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(
                1.0, 0.0), // 10% of the width, so there are ten blinds.
            colors: [
              this.widget.backgroundColor1,
              this.widget.backgroundColor2
            ], // whitish to gray
            // tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 150.0, bottom: 50.0),
              child: Center(
                child: new Column(
                  children: <Widget>[
                    buildCircleAvatar(),
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
            buildUserIdField(context),
            buildPasswordInput(context),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(child: buildSubmitButton(context)),
                ],
              ),
            ),
            if (vm.mode == SignInScreenMode.signIn)
              _buildRegisterButton(context),
            if (vm.mode == SignInScreenMode.register)
              _buildAlreadyHaveAccountButton(context),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 10.0, bottom: 20.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: InkWell(
                      onTap: () async {
                        // await vm.progressWithoutUsername();
                        // Navigator.pushNamed(context, RouteNames.MAIN);
                      },
                      child: new FlatButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20.0),
                        color: Colors.transparent,
                        onPressed: () async {
                          await vm.progressWithoutUsername();
                          Navigator.pushNamed(context, RouteNames.INIT_START);
                        },
                        child: Text(
                          "Ohne Account verwenden",
                          style: TextStyle(
                              color:
                                  this.widget.foregroundColor.withOpacity(0.8)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
