import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  User _user;

  User get user => _user;

  loggedIn(User u) {
    _user = u;
    notifyListeners();
  }

  loggedOut() {
    _user = null;
    notifyListeners();
  }
}
