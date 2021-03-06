import 'package:flutter/material.dart';
import 'package:prompt/shared/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:prompt/viewmodels/init_session_view_model.dart';

class CabuuLinkScreen extends StatelessWidget {
  const CabuuLinkScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<InitSessionViewModel>(context);
    return Container(
      child: ListView(
        children: [
          Text(
            "Verknüpfung mit cabuu",
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
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
                  "Ja, ich möchte an der Studie teilnehmen",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
          UIHelper.verticalSpaceMedium(),
          Text(
            "Gib hier die E-Mail-Adresse ein, mit der du bei cabuu angemeldet bist",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          UIHelper.verticalSpaceMedium(),
          buildEmailField(context),
          UIHelper.verticalSpaceMedium(),
          Text(
            "Falls du bei cabuu auch mit einem Benutzernamen angemeldet bist, gib diesen bitte hier ein",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          UIHelper.verticalSpaceMedium(),
          buildUserIdField(context),
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
              keyboardType: TextInputType.name,
              textAlign: TextAlign.center,
              onChanged: (text) {
                // Provider.of<LoginState>(context).userId =
                vm.cabuuLinkUserName = text;
              },
              validator: (String arg) {
                return null;
              },
              decoration: InputDecoration(
                // labelText: "Email",
                // alignLabelWithHint: true,
                border: InputBorder.none,
                hintText: 'Nutzername',
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildEmailField(BuildContext context) {
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
                vm.cabuuLinkEmail = text;
              },
              validator: (String arg) {
                return null;
              },
              decoration: InputDecoration(
                // labelText: "Email",
                // alignLabelWithHint: true,
                border: InputBorder.none,
                hintText: 'E-Mail',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
