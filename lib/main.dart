import 'dart:async';
import 'package:admin/authentication.dart';
import 'package:admin/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'dashboard.dart';
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
  late StreamSubscription<User?> authStream;
  UserModel userModel = UserModel();

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp().then((value) {
        print('after initialize about to subscribe');
        subscribeToAuthStream();
      });
      setState(() {
        print('setting initialized');
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
    authStream.cancel();
    super.dispose();
  }

  void subscribeToAuthStream() {
    try {
      authStream = FirebaseAuth.instance.authStateChanges().listen((user) {
        setState(() {
          if (user == null) {
            userModel.loggedOut();
          } else {
            print('user logged in: ' + user.email!);
            userModel.loggedIn(user);
          }
        });
      });
    } on Exception catch (e) {
      print('error: ' + e.toString());
    }
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
        initialRoute: '/',
        routes: {
          '/': (context) => Dashboard(),
          '/authentication': (context) => AuthenticationWidget(),
          '/profile': (context) => ProfileScreen(),
        },
      ),
    );
  }
}

class Loading extends StatelessWidget {
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
