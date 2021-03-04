import 'package:admin/model/userModel.dart';
import 'package:admin/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatefulWidget {
  AppScaffold({
    required this.body,
    this.title = 'Palm Beach Facial Plastic Surgery',
  });

  final String title;
  final Widget body;

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  late UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, uModel, child) {
      userModel = uModel;

      return Scaffold(
        // drawer: MyDrawer(),
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.person),
              onSelected: menuSelection,
              itemBuilder: (BuildContext context) {
                return <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "Profile",
                    enabled: Utility.isUserSignedIn(),
                    child: Text("Profile"),
                  ),
                  PopupMenuItem<String>(
                    value: "Settings",
                    child: Text("Settings"),
                  ),
                  PopupMenuItem<String>(
                    value: "Logout",
                    enabled: Utility.isUserSignedIn(),
                    child: Text("Logout"),
                  ),
                ].toList();
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () => null,
            ),
          ],
        ),
        body: widget.body,
      );
    });
  }

  void menuSelection(String value) {
    switch (value) {
      case "Logout":
        logout();
        break;
      case "Settings":
        settings();
        break;
      case "Profile":
        profile();
        break;
      default:
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  void settings() {}

  void profile() {
    Navigator.pushNamed(context, '/profile');
  }
}
