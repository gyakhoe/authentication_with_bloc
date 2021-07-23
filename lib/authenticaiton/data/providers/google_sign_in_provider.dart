import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider {
  final GoogleSignIn _googleSignIn;
  GoogleSignInProvider({
    required GoogleSignIn googleSignIn,
  }) : _googleSignIn = googleSignIn;

  Future<AuthCredential> login() async {
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    return authCredential;
  }

  Future<void> logout() async {
    if (await _googleSignIn.isSignedIn()) {
      _googleSignIn.signOut();
    }
  }
}
