import 'package:admin/appScaffold.dart';
import 'package:admin/utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/userModel.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (Utility.isNoUserSignedIn()) {
    //   print('user is nulll');
    //   Future.delayed(
    //     Duration(microseconds: 1),
    //     () => Navigator.pushNamed(context, '/authentication'),
    //   );
    // }

    return AppScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<UserModel>(builder: (context, userModel, child) {
              return dashboardBody(context, userModel);
            }),
          ],
        ),
      ),
    );
  }

  Widget dashboardBody(BuildContext context, UserModel userModel) {
    if (Utility.isNoUserSignedIn()) {
      return ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/authentication'),
        child: Text('Sign In'),
      );
    } else {
      return Text(
        'Dashboard' +
            (Utility.isUserSignedIn()
                ? userModel.firebaseUser.email
                : 'No User Signed In'),
      );
    }
  }
}
