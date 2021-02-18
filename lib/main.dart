import 'dart:async';
import 'package:admin/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dashboard.dart';
import 'package:provider/provider.dart';
import 'model/userModel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;
  StreamSubscription<User> authStream;
  UserModel userModel = UserModel();

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp().then((value) {
        print('after initialize about to subscribe');
        subscribeToAuthStream();
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  void dispose() {
    if (authStream != null) {
      unsubscribeFromAuthStream();
    }
    super.dispose();
  }

  void subscribeToAuthStream() {
    try {
      authStream = FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          userModel.loggedOut();
        } else {
          print('user logged in: ' + user.email);
          userModel.loggedIn(user);
        }
      });
    } on Exception catch (e) {
      print('error: ' + e.toString());
    }
  }

  void unsubscribeFromAuthStream() {
    authStream.cancel();
    authStream = null;
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return SomethingWentWrong();
    }

    if (!_initialized) {
      return Loading();
    }

    return ChangeNotifierProvider(
      create: (context) => userModel,
      child: MaterialApp(
        routes: {
          // '/': (context) => HomeWidget(),
          '/': (context) => Dashboard(),
          // '/dashboard': (context) => Dashboard(),
          '/authentication': (context) => AuthenticationWidget(),
          // '/login': (context) => LoginAccountWidget(),
          // '/createaccount': (context) => RegisterNewAccountWidget(),
        },
      ),
    );
  }
}

class Loading extends StatelessWidget {
  Loading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Loading...',
            ),
          ],
        ),
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  SomethingWentWrong({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Something went wrong!',
            ),
          ],
        ),
      ),
    );
  }
}
