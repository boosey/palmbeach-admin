// import 'package:admin/appScaffold.dart.disabled';
import 'dart:async';
import 'package:admin/appScaffold.dart';
import 'package:admin/model/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'credentialsWidget.dart';

class LoginAccountWidget extends StatefulWidget {
  @override
  State<LoginAccountWidget> createState() {
    return LoginAccountState();
  }
}

class LoginAccountState extends State<LoginAccountWidget> {
  Future<void> login(UserCredentials credentials) {
    print('logging in ' + credentials.uid);
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: credentials.uid, password: credentials.pwd);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
    return Future.value(null);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    StreamController<UserCredentials> credentialsStream =
        StreamController<UserCredentials>();

    credentialsStream.stream.listen((credentials) {
      login(credentials);
    });

    return AppScaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 400,
              height: 300,
              child: Consumer<UserModel>(builder: (context, userModel, child) {
                print('in login widget consumer');
                return CredentialsWidget(
                  titleText: 'Login to Your Account',
                  buttonText: 'Login',
                  credentialsStream: credentialsStream,
                );
              }),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/createaccount'),
              child: Text("Create a New Account"),
            ),
          ],
        ),
      ),
    );
  }
}
