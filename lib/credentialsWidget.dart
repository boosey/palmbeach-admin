import 'dart:async';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

typedef Action = Future<void> Function(String uid, String pwd);

class UserCredentials {
  String uid;
  String pwd;
}

class CredentialsWidget extends StatefulWidget {
  final String titleText;
  final String buttonText;
  final StreamController<UserCredentials> credentialsStream;

  const CredentialsWidget({
    Key key,
    this.buttonText,
    this.titleText,
    this.credentialsStream,
  }) : super(key: key);

  @override
  State<CredentialsWidget> createState() {
    return CredentialsState();
  }
}

class CredentialsState extends State<CredentialsWidget> {
  TextEditingController _uidController;
  TextEditingController _pwdController;
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    _uidController = TextEditingController();
    _pwdController = TextEditingController();
  }

  void dispose() {
    _uidController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  void streamCredentials() {
    if (_formKey.currentState.validate()) {
      UserCredentials credentials = UserCredentials();
      credentials.uid = _uidController.text;
      credentials.pwd = _pwdController.text;
      widget.credentialsStream.add(credentials);
      widget.credentialsStream.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            widget.titleText,
          ),
          TextFormField(
            controller: _uidController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'User Id',
            ),
            validator: (value) {
              if (EmailValidator.validate(value)) {
                return null;
              } else {
                return "Please enter a valid email address";
              }
            },
          ),
          TextFormField(
            controller: _pwdController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
            validator: (value) {
              if (value.length >= 8) {
                return null;
              } else {
                return "Password must be at least 8 characters";
              }
            },
          ),
          ElevatedButton(
            onPressed: streamCredentials,
            child: Text(widget.buttonText),
          ),
        ],
      ),
    );
  }
}
