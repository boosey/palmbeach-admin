import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatefulWidget {
  AppScaffold({
    @required this.body,
    Key key,
    this.title,
  }) : super(key: key);

  final String title;
  final Widget body;

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => null,
        ),
        title: Text("Palm Beach Facial Plastic Surgery"),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.person),
            onSelected: menuSelection,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "Profile",
                  child: Text("Profile"),
                  // enabled: user != null,
                ),
                PopupMenuItem<String>(
                  value: "Settings",
                  child: Text("Settings"),
                ),
                PopupMenuItem<String>(
                  value: "Logout",
                  child: Text("Logout"),
                  // enabled: user != null,
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
  }

  void settings() {}

  void profile() {}
}
