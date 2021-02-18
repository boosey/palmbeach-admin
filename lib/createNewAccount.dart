import 'dart:async';
import 'package:admin/appScaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'credentialsWidget.dart';

class RegisterNewAccountWidget extends StatefulWidget {
  @override
  State<RegisterNewAccountWidget> createState() {
    return RegisterNewAccountState();
  }
}

class RegisterNewAccountState extends State<RegisterNewAccountWidget> {
  Future<void> createAccount(UserCredentials credentials) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: credentials.uid,
        password: credentials.pwd,
      );
      Navigator.pushReplacementNamed(context, '/');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    StreamController<UserCredentials> credentialsStream =
        StreamController<UserCredentials>();

    credentialsStream.stream.listen((credentials) {
      createAccount(credentials);
    });

    return AppScaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 400,
              height: 300,
              child: CredentialsWidget(
                titleText: 'Register New Account',
                buttonText: 'Register',
                credentialsStream: credentialsStream,
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: Text("Sign Into an Existing Account"),
            )
          ],
        ),
      ),
    );
  }
}
