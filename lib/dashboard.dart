import 'dart:async';
import 'package:admin/appScaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null)
      Future.delayed(
        Duration(microseconds: 1),
        () => Navigator.pushNamed(context, '/authentication'),
      );

    return AppScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Dashboard',
            ),
          ],
        ),
      ),
    );
  }
}
