import 'package:firebase_auth/firebase_auth.dart' as firebase;

class User {
  String id = '';
  String name = '';

  User();

  User.fromFirebaseUser(firebase.User? firebaseUser) {
    if (firebaseUser == null) return;
    id = firebaseUser.uid;
    name = firebaseUser.displayName?? 'Anonymous';
  }
}