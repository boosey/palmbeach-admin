import 'package:admin/appScaffold.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
