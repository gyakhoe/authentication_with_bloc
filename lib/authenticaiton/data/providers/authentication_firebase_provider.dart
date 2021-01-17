import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationFirebaseProvider {
  final FirebaseAuth _firebaseAuth;
  AuthenticationFirebaseProvider({
    @required FirebaseAuth firebaseAuth,
  })  : assert(firebaseAuth != null),
        _firebaseAuth = firebaseAuth;

  Stream<User> getAuthStates() {
    return _firebaseAuth.authStateChanges();
  }

  Future<User> login({
    @required AuthCredential credential,
  }) async {
    UserCredential userCredential =
        await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
