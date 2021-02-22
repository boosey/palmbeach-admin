import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'appScaffold.dart';

class AuthenticationWidget extends StatefulWidget {
  AuthenticationWidget({Key key}) : super(key: key);

  @override
  _AuthenticationWidgetState createState() => _AuthenticationWidgetState();
}

enum Mode { login, createaccount }
enum Item { button, link, heading }

class _AuthenticationWidgetState extends State<AuthenticationWidget> {
  static const Details = {
    Mode.login: {
      Item.button: 'Sign In',
      Item.heading: 'Sign into Your Account',
      Item.link: 'Create a New Account',
    },
    Mode.createaccount: {
      Item.button: 'Create Account',
      Item.heading: 'Create a New Account',
      Item.link: 'Sign in to Existing Account',
    },
  };

  Mode mode = Mode.login;
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

  @override
  Widget build(BuildContext context) {
    var details = Details[mode];

    return AppScaffold(
      title: 'Sign In',
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 400,
              height: 300,
              child:
                  // Consumer<UserModel>(builder: (context, userModel, child) {
                  //   return
                  Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      details[Item.heading],
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
                      onPressed: executeAction,
                      child: Text(details[Item.button]),
                    ),
                  ],
                ),
              ),
              // }),
            ),
            TextButton(
              onPressed: () => executeLink(),
              child: Text(details[Item.link]),
            ),
          ],
        ),
      ),
    );
  }

  void executeLink() {
    print('in executeLink');
    setState(() {
      if (mode == Mode.login)
        mode = Mode.createaccount;
      else
        mode = Mode.login;
    });
  }

  void executeAction() {
    if (_formKey.currentState.validate()) {
      if (mode == Mode.login)
        login(
          _uidController.text,
          _pwdController.text,
        );
      else
        createAccount(
          _uidController.text,
          _pwdController.text,
        );
    }
    Navigator.pop(context);
  }

  Future<void> login(String uid, String pwd) {
    print('logging in ' + uid);
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: uid,
        password: pwd,
      );
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

  Future<void> createAccount(String uid, String pwd) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: uid,
        password: pwd,
      );
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
}
