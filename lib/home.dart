import 'package:admin/dashboard.dart';
import 'package:admin/loginPane.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/userModel.dart';

class HomeWidget extends StatefulWidget {
  @override
  State<HomeWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, userModel, child) {
      User user = userModel.user;

      if (user != null) {
        print(userModel);
        print(user.uid);
        return Dashboard();
      } else {
        print('user is null;');
        return LoginAccountWidget();
      }
    });
  }
}
