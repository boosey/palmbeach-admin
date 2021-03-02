import 'package:admin/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminOnly extends StatelessWidget {
  final Widget child;

  AdminOnly({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, userModel, c) {
        return Visibility(
          child: child,
          visible: userModel.isAdmin,
        );
      },
    );
  }
}
