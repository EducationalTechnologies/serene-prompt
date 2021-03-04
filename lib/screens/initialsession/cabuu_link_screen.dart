import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serene/viewmodels/init_session_view_model.dart';

class CabuuLinkScreen extends StatelessWidget {
  const CabuuLinkScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Checkbox(
                  tristate: false,
                  onChanged: (value) {
                    vm.setConsentedValue(value);
                  },
                  value: vm.consented),
              Flexible(
                child: Text(
                  "Ja, ich möchte an der Studie Teilnehmen",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
          Text(
            "Gib hier die Email Adresse oder den Benutzernamen ein, mit der du bei Cabuu registriert bist",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          buildUserIdField(context)
        ],
      ),
    );
  }

  buildUserIdField(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);
    return new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 40.0, right: 40.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.black, width: 0.5, style: BorderStyle.solid),
        ),
      ),
      padding: const EdgeInsets.only(left: 0.0, right: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Expanded(
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (text) {
                // Provider.of<LoginState>(context).userId =
                vm.cabuuLinkUserName = text;
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
                hintText: 'Email oder Nutzername',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
