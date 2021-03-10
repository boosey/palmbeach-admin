// import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class UserModel extends ChangeNotifier {
  User? _user;
  late UserProfile profile;
  bool isAdmin = false;

  User? get firebaseUser => _user;

  loggedIn(User u) async {
    _user = u;
    profile = UserProfile(_user!.uid);
    var tokenResult = await _user!.getIdTokenResult();
    isAdmin = tokenResult.claims!.containsKey('admin');

    notifyListeners();
  }

  loggedOut() {
    if (_user != null) {
      // profile.cancelSubscription();
      _user = null;
      notifyListeners();
    }
  }

  bool isLoggedIn() {
    return _user != null;
  }

  void save() {
    profile.save();
    if (isAdmin)
      setAdminClaim();
    else
      clearAdminClaim();
  }

  void setAdminClaim() async {
    HttpsCallable manageAdminClaim =
        FirebaseFunctions.instance.httpsCallable('setAdminClaim');
    await manageAdminClaim.call(_user!.uid);
  }

  void clearAdminClaim() async {
    HttpsCallable manageAdminClaim =
        FirebaseFunctions.instance.httpsCallable('clearAdminClaim');
    await manageAdminClaim.call(_user!.uid);
  }
}

class UserProfile {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final String uid;
  // late StreamSubscription subscription;
  String firstName = '';
  String lastName = '';

  UserProfile(this.uid) {
    print('uid: ' + this.uid);

    firstName = "Hard";
    lastName = "Coded";

    print("hard coded name set");

    // users.doc(uid).get().then((profile) {
    //   firstName = profile['firstName'];
    //   lastName = profile['lastName'];
    // }).onError((error, stackTrace) {
    //   print("Error: " + error.toString());
    // });
  }

  void save() {
    users.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
    });
  }
}
