import 'package:firebase_auth/firebase_auth.dart';

class Utility {
  static bool isUserSignedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static bool isNoUserSignedIn() {
    return !isUserSignedIn();
  }
}
